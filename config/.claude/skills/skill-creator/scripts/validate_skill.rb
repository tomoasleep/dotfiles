#!/usr/bin/env ruby

require 'yaml'

class SkillValidator
  def initialize(skill_path)
    @skill_path = skill_path
  end

  def run
    validate_structure
    validate_skill_md
    puts "✓ Skill '#{@skill_path}' is valid"
  end

  private

  def validate_structure
    unless Dir.exist?(@skill_path)
      puts "Error: Skill directory '#{@skill_path}' does not exist"
      exit 1
    end

    skill_md = File.join(@skill_path, 'SKILL.md')
    return if File.exist?(skill_md)

    puts "Error: SKILL.md not found in '#{@skill_path}'"
    exit 1
  end

  def validate_skill_md
    skill_md = File.join(@skill_path, 'SKILL.md')
    content = File.read(skill_md)

    frontmatter = extract_frontmatter(content)
    validate_frontmatter(frontmatter)

    skill_dir_name = File.basename(@skill_path)
    validate_name_match(frontmatter['name'], skill_dir_name)

    validate_description(frontmatter['description'])
  end

  def extract_frontmatter(content)
    if content =~ /\A---\s*\n(.*?)\n---\s*\n/m
      yaml_content = ::Regexp.last_match(1)
      begin
        YAML.safe_load(yaml_content)
      rescue Psych::SyntaxError => e
        puts "Error: Invalid YAML in frontmatter: #{e.message}"
        exit 1
      end
    else
      puts 'Error: No YAML frontmatter found in SKILL.md'
      exit 1
    end
  end

  def validate_frontmatter(frontmatter)
    unless frontmatter.is_a?(Hash)
      puts 'Error: Frontmatter must be a YAML object'
      exit 1
    end

    unless frontmatter['name']
      puts "Error: Missing required field 'name' in frontmatter"
      exit 1
    end

    return if frontmatter['description']

    puts "Error: Missing required field 'description' in frontmatter"
    exit 1
  end

  def validate_name_match(frontmatter_name, dir_name)
    return unless frontmatter_name != dir_name

    puts "Error: Frontmatter name '#{frontmatter_name}' does not match directory name '#{dir_name}'"
    exit 1
  end

  def validate_description(description)
    puts "Warning: Description is too short (#{description.length} characters)" if description.length < 10

    return unless description == description.upcase

    puts 'Warning: Description appears to be placeholder text'
  end
end

if __FILE__ == $0
  if ARGV.empty?
    puts 'Usage: validate_skill.rb <skill-path>'
    exit 1
  end

  SkillValidator.new(ARGV[0]).run
end
