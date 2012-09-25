class AddSymbolToTradeCaclulations < ActiveRecord::Migration
  def self.up
    add_column :trade_calculations, :symbol, :string
  end

  def self.down
    remove_column :trade_calculations, :symbol
  end
end
