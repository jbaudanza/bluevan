class Application < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name

  validates_uniqueness_of :name
  validates_format_of :name, :with => /\A\w+\Z/,
      :message => 'must only contain word characters and no spaces'

  # TODO: all keys should match this regexp /\A[A-Za-z_0-9]+\Z/
  serialize :environment, Hash

  def port
    6000 + id
  end

  def slug_dir
    "/home/app/slugs/#{name}"
  end

  def generate_upstart
    system('foreman', 'export',
        '--user', 'app',
        '--app', name,
        '--port', port.to_s,
        '--root', slug_dir,
        '--concurrency', 'web=1',
        'upstart', '/etc/init')
  end

  def generate_env_file
    environment = {
      'RAILS_ENV' => 'production',
      'RACK_ENV' => 'production',
      'APP_NAME' => 'app_name',
      'DATABASE_URL' => "postgres://app:app@localhost/#{name}"
    }.merge(self.environment)

    File.open("#{slug_dir}/.env", 'w') do |file|
      environment.each do |key, value|
        file.puts "#{key}=#{value}"
      end
    end
  end
end
