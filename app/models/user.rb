class User < ActiveRecord::Base
  has_many :applications
  has_many :public_keys

  validates_presence_of :name, :github_id, :github_login, :access_token

  GITHUB_CLIENT = OAuth2::Client.new(
    ENV['GITHUB_OAUTH2_CLIENT_ID'],
    ENV['GITHUB_OAUTH2_CLIENT_SECRET'],
    :site => 'https://api.github.com',
    :authorize_url => 'https://github.com/login/oauth/authorize',
    :token_url => 'https://github.com/login/oauth/access_token',
    :token_method => :post)

  def self.jon
    find_by_github_id(35914)
  end

  def self.find_or_create_by_oauth2(api_client)
    response = JSON.parse(api_client.get('/user').body)

    needs_update = true

    user = find_or_create_by_github_id(response["id"]) do |user|
      user.update_from_github(response)
      user.access_token = api_client.token
      needs_update = false
    end

    # Update an existing users access token
    if needs_update
      user.update_from_github(response)
      user.access_token = api_client.token
      user.save!
    end

    user
  end

  # Assigns attributes based on a response from a github profile
  def update_from_github(response)
    self.name = response['name']
    self.github_login = response['login']
  end

  def update_keys!
    new_keys = JSON.parse(api_client.get('/user/keys').body)
    transaction do
      public_keys.delete_all
      new_keys.each do |atts|
        public_keys.create!(atts)
      end
    end
  end

  def api_client
    OAuth2::AccessToken.new(User::GITHUB_CLIENT, self.access_token)
  end
end