#!/usr/bin/env ruby
puts ARGV.inspect

# ln -s /home/app/slugs/bluevan/post-receive.rb /home/app/repos/bluevan/hooks/post-receive

HOME_DIR = '/home/app'
BUILDPACK_DIR = "#{HOME_DIR}/buildpacks/heroku-buildpack-ruby".freeze
RELEASE_DIR = "#{HOME_DIR}/slugs/bluevan"
CACHE_DIR = "#{HOME_DIR}/cache/"

puts "Checking out master"

system({'GIT_WORK_TREE' => RELEASE_DIR}, 'git reset --hard master')

# TODO: slurp the output of this script
if system("#{BUILDPACK_DIR}/bin/detect", RELEASE_DIR)
  system("#{BUILDPACK_DIR}/bin/compile", RELEASE_DIR, CACHE_DIR)

  # TODO: Run the /bin/release script to setup a Procfile
else
  puts "ERROR: No suitable buildback found"
end

