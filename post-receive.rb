#!/usr/bin/env ruby
require 'yaml'

REPO_NAME = Dir.pwd.split('/').last.freeze
HOME_DIR = '/home/app'.freeze
BUILDPACK_PARENT_DIR = "#{HOME_DIR}/buildpacks/".freeze
RELEASE_DIR = "#{HOME_DIR}/slugs/#{REPO_NAME}".freeze
CACHE_DIR = "#{HOME_DIR}/cache/#{REPO_NAME}".freeze

Dir.mkdir(RELEASE_DIR) unless File.exists?(RELEASE_DIR)
Dir.mkdir(CACHE_DIR) unless File.exists?(CACHE_DIR)

system({'GIT_WORK_TREE' => RELEASE_DIR}, 'git reset --hard master')

environment = {
  'RAILS_ENV' => 'production',
  'RACK_ENV' => 'production',
  'DATABASE_URL' => "postgres://app@app:localhost/#{REPO_NAME}"
}

Dir.glob("#{BUILDPACK_PARENT_DIR}/*").each do |buidpack_dir|
  slug_type = `#{buidpack_dir}/bin/detect #{RELEASE_DIR}`
  if $?.success?
    puts "Detected #{slug_type.chomp}"

    system("#{buidpack_dir}/bin/compile", RELEASE_DIR, CACHE_DIR)

    yaml = `#{buidpack_dir}/bin/release #{RELEASE_DIR}`
    parsed = YAML.parse(yaml)
    #puts parsed['default_process_types'].inspect

    # Create environment file
    File.open("#{RELEASE_DIR}/.env", 'w') do |file|
      environment.each do |key, value|
        file.puts "#{key}=#{value}"
      end
    end
  end
end
