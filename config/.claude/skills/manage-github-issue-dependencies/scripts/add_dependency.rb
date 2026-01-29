#!/usr/bin/env ruby
require 'json'

def gh_api(endpoint, method: :get, body: nil)
  cmd = if body && method == :post
          "echo '#{body.to_json.gsub("'",
                                     "'\\\\''")}' | gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' --method POST --input - #{endpoint}"
        elsif method == :delete
          "gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' --method DELETE #{endpoint}"
        else
          "gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' #{endpoint}"
        end

  output = `#{cmd} 2>&1`
  exit_status = $?.exitstatus

  unless exit_status.zero?
    puts "Error: Command failed with exit code #{exit_status}"
    puts output
    exit 1
  end

  JSON.parse(output)
end

def add_dependency(owner, repo, issue_number, blocking_issue_number)
  blocking_issue = gh_api("repos/#{owner}/#{repo}/issues/#{blocking_issue_number}")
  blocking_issue_id = blocking_issue['id']

  result = gh_api(
    "repos/#{owner}/#{repo}/issues/#{issue_number}/dependencies/blocked_by",
    method: :post,
    body: { issue_id: blocking_issue_id }
  )

  puts "Success: Issue ##{issue_number} is now blocked by issue ##{blocking_issue_number}"
  puts "URL: #{result['html_url']}"
end

if ARGV.length != 3
  puts 'Usage: ruby add_dependency.rb <owner/repo> <issue_number> <blocking_issue_number>'
  puts 'Example: ruby add_dependency.rb octocat/Hello-World 42 43'
  exit 1
end

repo_arg = ARGV[0]
issue_number = ARGV[1]
blocking_issue_number = ARGV[2]

unless repo_arg.include?('/')
  puts 'Error: Repository must be in format owner/repo'
  exit 1
end

owner, repo = repo_arg.split('/', 2)
add_dependency(owner, repo, issue_number, blocking_issue_number)
