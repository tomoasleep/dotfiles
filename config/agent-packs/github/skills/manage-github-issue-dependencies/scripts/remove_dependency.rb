#!/usr/bin/env ruby
require 'json'

def gh_api(endpoint, method: :get)
  cmd = if method == :delete
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

def remove_dependency(owner, repo, issue_number, blocking_issue_number)
  blocking_issue = gh_api("repos/#{owner}/#{repo}/issues/#{blocking_issue_number}")
  blocking_issue_id = blocking_issue['id']

  result = gh_api(
    "repos/#{owner}/#{repo}/issues/#{issue_number}/dependencies/blocked_by/#{blocking_issue_id}",
    method: :delete
  )

  puts "Success: Removed dependency - Issue ##{issue_number} is no longer blocked by issue ##{blocking_issue_number}"
  puts "URL: #{result['html_url']}"
end

if ARGV.length != 3
  puts 'Usage: ruby remove_dependency.rb <owner/repo> <issue_number> <blocking_issue_number>'
  puts 'Example: ruby remove_dependency.rb octocat/Hello-World 42 43'
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
remove_dependency(owner, repo, issue_number, blocking_issue_number)
