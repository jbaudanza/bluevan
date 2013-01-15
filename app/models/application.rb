class Application < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name

  validates_uniqueness_of :name
  validates_format_of :name, :with => /\A\w+\Z/,
      :message => 'must only contain word characters and no spaces'

  # TODO: all keys should match this regexp /\A[A-Za-z_0-9]+\Z/
  serialize :environment, Hash
end