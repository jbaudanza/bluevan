class PublicKey < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :url, :verified, :key
  attr_accessible :title, :url, :verified, :key

  def self.generate_ssh_config
    PublicKey.joins(:user).where('users.invited').each do |public_key|
      puts public_key.key
    end
  end
end