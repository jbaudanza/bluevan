class Initial < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.timestamps :null => false
      t.string :name, :null => false
      t.string :github_login, :null => false
      t.integer :github_id, :null => false
      t.string :name, :null => false
      t.string :access_token, :null => false
      t.boolean :invited, :null => false, :default => false
    end

    create_table :applications do |t|
      t.timestamps :null => false
      t.string :name, :null => false
      t.belongs_to :user, :null => false
      t.text :environment, :null => false
    end

    create_table :public_keys do |t|
      t.timestamps :null => false
      t.belongs_to :user, :null => false
      t.text :key, :null => false
      t.string :url, :null => false
      t.string :title, :null => false
      t.boolean :verified, :null => false
    end

    add_index :applications, :user_id
    add_index :applications, :name

    add_index :public_keys, :user_id
  end

  def down
    drop_table :public_keys
    drop_table :applications
    drop_table :users
  end
end
