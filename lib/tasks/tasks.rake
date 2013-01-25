desc "Generates a .ssh/config file with all the public keys in the database"
task :generate_ssh_config => :environment do
  PublicKey.generate_ssh_config
end

HOME_DIR = '/home/app'.freeze
BUILDPACK_PARENT_DIR = "#{HOME_DIR}/buildpacks/".freeze

# TODO:
# - Use a new build_dir for each deploy
# - Restart the app after a deploy
desc "This is invoked from a repos's post-receive hook"
task :post_receive => :environment do
  app_name = ENV['APP_NAME']
  repo_dir  = "#{HOME_DIR}/repos/#{app_name}"
  build_dir = "#{HOME_DIR}/slugs/#{app_name}"
  cache_dir = "#{HOME_DIR}/cache/#{app_name}"

  Dir.mkdir(cache_dir) unless File.exists?(cache_dir)

  # Ensure there is a clean build_dir
  if File.exists?(build_dir)
    # TODO: This is breaking deploys for the bluevan app
    # FileUtils.rm_rf(Dir.glob(build_dir + '/*'))
  else
    Dir.mkdir(build_dir)
  end

  system(
      {'GIT_WORK_TREE' => build_dir, 'GIT_DIR' => repo_dir},
      'git reset --hard master')

  # Detect and execute a buildpack
  Dir.glob("#{BUILDPACK_PARENT_DIR}/*").each do |buidpack_dir|
    slug_type = `#{buidpack_dir}/bin/detect #{build_dir}`
    if $?.success?
      puts "Detected #{slug_type.chomp}"

      system(
          {'RUBYOPT' => nil},
          "#{buidpack_dir}/bin/compile", build_dir, cache_dir)

      yaml = `#{buidpack_dir}/bin/release #{build_dir}`
      parsed = YAML.parse(yaml)
      #puts parsed['default_process_types'].inspect

      break
    end
  end

  environment = {
    'RAILS_ENV' => 'production',
    'RACK_ENV' => 'production',
    'APP_NAME' => 'app_name',
    'DATABASE_URL' => "postgres://app:app@localhost/#{app_name}"
  }

  # Create environment file
  File.open("#{build_dir}/.env", 'w') do |file|
    environment.each do |key, value|
      file.puts "#{key}=#{value}"
    end
  end

end
