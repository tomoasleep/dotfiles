#!/usr/bin/env ruby
require 'json'

def gh_api(endpoint)
  output = `gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' '#{endpoint}' 2>&1`
  exit_status = $?.exitstatus

  unless exit_status.zero?
    puts "Error: Command failed with exit code #{exit_status}"
    puts output
    exit 1
  end

  JSON.parse(output)
end

def list_blocking(owner, repo, issue_number)
  issues = gh_api("repos/#{owner}/#{repo}/issues/#{issue_number}/dependencies/blocking")

  if issues.empty?
    puts "Issue ##{issue_number} is not blocking any issues."
    return
  end

  puts "Issue ##{issue_number} is blocking #{issues.length} issue(s):\n"

  issues.each do |issue|
    puts "  - ##{issue['number']}: #{issue['title']}"
    puts "    State: #{issue['state']}"
    puts "    URL: #{issue['html_url']}"
    puts "    ID: #{issue['id']}"
    puts
  end
end

if ARGV.length != 2
  puts 'Usage: ruby list_blocking.rb <owner/repo> <issue_number>'
  puts 'Example: ruby list_blocking.rb octocat/Hello-World 42'
  exit 1
end

repo_arg = ARGV[0]
issue_number = ARGV[1]

unless repo_arg.include?('/')
  puts 'Error: Repository must be in format owner/repo'
  exit 1
end

owner, repo = repo_arg.split('/', 2)
list_blocking(owner, repo, issue_number)
