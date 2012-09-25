class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.float :trading_capital
      t.integer :risk_percentage
      t.string :login
      t.string :email
      t.string :salt
      t.string :crypted_password
      t.datetime :remember_token_expires_at
      t.string :remember_token
      t.timestamps
    end
    add_index :members, :login
  end

  def self.down
    remove_index :members, :login
    drop_table :members
  end
end