class CreateTradeLogs < ActiveRecord::Migration
  def self.up
    create_table :trade_logs do |t|
      t.integer :trade_calculation_id
      t.date :date
      t.string :action
      t.integer :units
      t.float :price
      t.float :total
      t.text :notes
      
      t.timestamps
    end
    add_index :trade_logs, :trade_calculation_id
  end

  def self.down
    remove_index :trade_logs, :trade_calculation_id
    drop_table :trade_logs
  end
end
