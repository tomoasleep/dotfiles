#!/usr/bin/env ruby

require 'fileutils'
require 'optparse'

class SkillInitializer
  def initialize(skill_name)
    @skill_name = skill_name
    @base_dir = File.expand_path('../..', __dir__)
  end

  def run
    validate_name!

    skill_dir = File.join(@base_dir, @skill_name)

    if Dir.exist?(skill_dir)
      puts "Error: Directory '#{@skill_name}' already exists"
      exit 1
    end

    create_structure(skill_dir)
    puts "Skill '#{@skill_name}' initialized successfully"
    puts "Location: #{skill_dir}"
  end

  private

  def validate_name!
    return if @skill_name.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/)

    puts "Error: Invalid skill name '#{@skill_name}'"
    puts "Skill names must use lowercase letters, numbers, and hyphens only (e.g., 'my-skill')"
    exit 1
  end

  def create_structure(skill_dir)
    FileUtils.mkdir_p(skill_dir)
    FileUtils.mkdir_p(File.join(skill_dir, 'scripts'))
    FileUtils.mkdir_p(File.join(skill_dir, 'references'))
    FileUtils.mkdir_p(File.join(skill_dir, 'assets'))

    skill_md = <<~MARKDOWN
      ---
      name: #{@skill_name}
      description: "TODO: Add a clear description of what this skill does and when it should be used"
      ---

      # #{@skill_name.split('-').map(&:capitalize).join(' ')}

      ## Description

      TODO: Describe the purpose and functionality of this skill.

      ## Instructions

      TODO: Provide step-by-step instructions for using this skill.

      ## Examples

      TODO: Add concrete examples of how this skill should be used.
    MARKDOWN

    File.write(File.join(skill_dir, 'SKILL.md'), skill_md)
  end
end

if __FILE__ == $0
  OptionParser.new do |opts|
    opts.banner = 'Usage: init_skill.rb [options] <skill-name>'
  end.parse!

  if ARGV.empty?
    puts 'Error: Skill name is required'
    puts 'Usage: init_skill.rb <skill-name>'
    exit 1
  end

  SkillInitializer.new(ARGV[0]).run
end
