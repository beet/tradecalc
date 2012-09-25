class CreateCharts < ActiveRecord::Migration
  def self.up
    create_table :charts do |t|
      t.integer :trade_calculation_id
      t.string :range
      t.string :chart_type
      t.string :size
      t.text :moving_averages
      t.text :exponential_moving_averages
      t.text :indicators
      t.text :chart_overlays

      t.timestamps
    end
    add_index :charts, :trade_calculation_id
  end

  def self.down
    remove_index :charts, :trade_calculation_id
    drop_table :charts
  end
end