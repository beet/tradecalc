class TradeLog < ActiveRecord::Base
  belongs_to :trade_calculation
  validates_associated :trade_calculation
  validates_presence_of :date, :action, :units, :price, :total
  before_validation :calculate_total
  
  def calculate_total
    self.total = ((units || 0.00) * (price || 0.00))
  end
end
