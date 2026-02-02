# frozen_string_literal: true

require 'json'
require 'open3'
require 'optparse'
require 'time'

Thread.report_on_exception = false

class PRWatcherError < StandardError; end
class PRNotFoundError < PRWatcherError; end
class CommandExecutionError < PRWatcherError; end

# Command runner for executing system commands
class RealCommandRunner
  def capture3(command)
    Open3.capture3(*command)
  end
end

# Watches GitHub Pull Request status
class PRWatcher
  def initialize(branch_name, command_runner = nil)
    @branch_name = sanitize_branch_name(branch_name)
    @command_runner = command_runner || RealCommandRunner.new
  end

  def fetch_pr
    command = build_command
    stdout, stderr, status = @command_runner.capture3(command)

    raise CommandExecutionError, "gh command failed: #{stderr}" unless status.success?

    parse_pr_data(stdout)
  rescue JSON::ParserError => e
    raise CommandExecutionError, "Failed to parse JSON: #{e.message}"
  end

  def format_pr(pr_data)
    return nil if pr_data.nil?

    TerminalRenderer.render(pr_data)
  end

  private

  def build_command
    [
      'gh', 'pr', 'list',
      '--head', @branch_name,
      '--json', 'number,state,mergeable,statusCheckRollup,latestReviews,reviewRequests,reviews,title',
      '--limit', '1'
    ]
  end

  def parse_pr_data(stdout)
    pr_list = JSON.parse(stdout)
    return nil if pr_list.empty?

    pr_list.first
  end

  def sanitize_branch_name(branch_name)
    return branch_name if branch_name.nil?

    branch_name.gsub(%r{[^a-zA-Z0-9._\-/]}, '')
  end
end

# Checks CI status and review status
module StatusChecker
  module_function

  def check_ci_status(status_check_rollup)
    result = { success: 0, failure: 0, pending: 0, total: 0 }

    return result unless status_check_rollup && !status_check_rollup.empty?

    status_check_rollup.each do |check|
      result[:total] += 1
      update_ci_result(result, check)
    end

    result
  end

  def update_ci_result(result, check)
    conclusion = check['conclusion']
    status = check['status']

    case conclusion
    when 'SUCCESS'
      result[:success] += 1
    when 'FAILURE'
      result[:failure] += 1
    else
      result[:pending] += 1 if pending_status?(status, conclusion)
    end
  end

  def pending_status?(status, conclusion)
    %w[IN_PROGRESS QUEUED].include?(status) || conclusion.nil?
  end

  REVIEW_STATES = {
    'APPROVED' => :approved,
    'CHANGES_REQUESTED' => :changes_requested,
    'COMMENTED' => :commented,
    'DISMISSED' => :dismissed,
    'PENDING' => :pending
  }.freeze

  def check_review_status(latest_reviews, review_requests = nil)
    result = { approved: 0, changes_requested: 0, commented: 0, dismissed: 0, pending: 0 }

    if latest_reviews && !latest_reviews.empty?
      latest_reviews.each do |review|
        state_key = REVIEW_STATES[review['state']]
        result[state_key] += 1 if state_key
      end
    end

    if review_requests
      count = if review_requests.is_a?(Array)
                review_requests.length
              elsif review_requests.is_a?(Hash) && review_requests['nodes'].is_a?(Array)
                review_requests['nodes'].length
              else
                0
              end

      result[:pending] += count if count.positive?
    end

    result
  end
end

# Renders PR status to terminal
module TerminalRenderer
  module_function

  def render(pr_data)
    ci_status = StatusChecker.check_ci_status(pr_data['statusCheckRollup'])
    review_status = StatusChecker.check_review_status(pr_data['latestReviews'], pr_data['reviewRequests'])

    ci_part = format_ci_status(ci_status)
    review_part = format_review_status(review_status)

    "#{format_state_and_mergeable(pr_data)} #{ci_part} #{review_part}] #{truncate_title(pr_data['title'])}"
  end

  def format_ci_status(ci_status)
    return 'Checks: –' if ci_status[:total].zero?

    parts = []
    format_parts(parts, ci_status, { success: '✓', failure: '✗', pending: '⏳' }, ci_status[:total])

    "Checks: #{parts.join(' ')}"
  end

  def format_review_status(review_status)
    parts = []
    format_parts(parts, review_status,
                 { approved: '👍', changes_requested: '❌', commented: '💬', dismissed: '❌', pending: '⏳' })

    "Review: #{parts.empty? ? '–' : parts.join(' ')}"
  end

  def format_parts(parts, status, emoji_map, total = nil)
    status.each do |key, value|
      next unless value.positive? && emoji_map[key]

      parts << if total
                 "#{emoji_map[key]}#{value}/#{total}"
               else
                 "#{emoji_map[key]}#{value}"
               end
    end
  end

  def format_state_and_mergeable(pr_data)
    state = pr_data['state']
    mergeable = pr_data['mergeable'] || 'UNKNOWN'
    "##{pr_data['number']} [#{state} #{mergeable}"
  end

  def truncate_title(title, max_length = 50)
    return '' unless title

    title.length > max_length ? "#{title[0...max_length]}..." : title
  end
end

# Helper class for git operations
class GitHelper
  def self.current_branch
    stdout, _, status = Open3.capture3('git', 'branch', '--show-current')
    return nil unless status.success?

    stdout.strip
  end
end

# Runner for watch mode with periodic updates
class WatchModeRunner
  def initialize(watcher, interval, output = $stdout)
    @watcher = watcher
    @interval = interval
    @output = output
    @first_run = true
  end

  def run
    loop do
      refresh_display
      sleep(@interval)
    rescue Interrupt
      @output.puts
      break
    end
  end

  private

  def refresh_display
    clear_line unless @first_run
    @first_run = false

    display_pr_status
  end

  def display_pr_status
    pr_data = @watcher.fetch_pr
    message = pr_data ? @watcher.format_pr(pr_data) : 'No PR found for branch'
    output_with_timestamp(message)
  rescue PRWatcherError => e
    output_with_timestamp("Error: #{e.message}")
  end

  def output_with_timestamp(message)
    @output.print "#{message} [#{Time.now.strftime('%H:%M:%S')}]"
    @output.flush
  end

  def clear_line
    @output.print "\r\033[K"
  end
end

# Command line interface
class CLI
  DEFAULT_OPTIONS = {
    watch: false,
    interval: 30,
    branch: nil
  }.freeze

  def self.run(argv = ARGV)
    new(argv).run
  end

  def initialize(argv)
    @argv = argv
    @options = parse_options
  end

  def run
    branch_name = determine_branch_name
    watcher = PRWatcher.new(branch_name)
    execute_mode(watcher, branch_name)
  rescue PRWatcherError => e
    warn "Error: #{e.message}"
    exit 1
  end

  private

  def parse_options
    options = DEFAULT_OPTIONS.dup

    OptionParser.new do |opts|
      opts.banner = 'Usage: ruby watch.rb [options]'

      define_watch_option(opts, options)
      define_branch_option(opts, options)
      define_help_option(opts)
    end.parse!(@argv)

    options
  end

  def define_watch_option(opts, options)
    opts.on('-w [SECONDS]', '--watch [SECONDS]', 'Watch mode with custom interval (default: 30s)') do |interval|
      set_watch_options(options, interval)
    end
  end

  def set_watch_options(options, interval)
    options[:watch] = true
    options[:interval] = (interval || '30').to_i
  end

  def define_branch_option(opts, options)
    opts.on('-b BRANCH', '--branch BRANCH', 'Specify branch name') do |branch|
      options[:branch] = branch
    end
  end

  def define_help_option(opts)
    opts.on('-h', '--help', 'Show this help') do
      puts opts
      exit
    end
  end

  def run_watch_mode(watcher, branch_name)
    puts "Watching PR for branch: #{branch_name} (interval: #{@options[:interval]}s)"
    puts 'Press Ctrl+C to stop'
    WatchModeRunner.new(watcher, @options[:interval]).run
  end

  def run_single_mode(watcher, branch_name)
    pr_data = watcher.fetch_pr
    if pr_data
      puts watcher.format_pr(pr_data)
    else
      puts "No PR found for branch: #{branch_name}"
    end
  end

  def determine_branch_name
    branch_name = @options[:branch] || GitHelper.current_branch
    raise PRWatcherError, 'Failed to get current branch name' unless branch_name

    branch_name
  end

  def execute_mode(watcher, branch_name)
    if @options[:watch]
      run_watch_mode(watcher, branch_name)
    else
      run_single_mode(watcher, branch_name)
    end
  end
end

CLI.run if __FILE__ == $PROGRAM_NAME
