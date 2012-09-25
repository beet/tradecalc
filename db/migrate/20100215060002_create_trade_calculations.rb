class CreateTradeCalculations < ActiveRecord::Migration
  def self.up
    create_table :trade_calculations do |t|
      t.integer :member_id
      t.string :name
      t.text :description
      t.integer :units
      t.float :purchase_price
      t.float :stop_loss_exit_price
      t.float :target_sale_price
      t.text :notes

      t.timestamps
    end
    add_index :trade_calculations, :member_id
  end

  def self.down
    remove_index :trade_calculations, :member_id
    drop_table :trade_calculations
  end
end
