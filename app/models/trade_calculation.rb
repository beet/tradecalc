class TradeCalculation < ActiveRecord::Base
  belongs_to :member
  validates_associated :member
  has_many :trade_logs, :dependent => :destroy
  has_one :chart, :dependent => :destroy
  
  validates_presence_of :member_id, :name, :symbol, :purchase_price, :stop_loss_exit_price, :target_sale_price

  def full_cost
    return 0.0 if units.blank? or purchase_price.blank?
    units * purchase_price
  end
  
  def risk
    return 0.0 if full_cost.blank? or units.blank? or stop_loss_exit_price.blank?
    full_cost - (units * stop_loss_exit_price)
  end
  
  def total_return
    return 0.0 if units.blank? or target_sale_price.blank?
    units * target_sale_price
  end
  
  def profit
    total_return - full_cost
  end
  
  def percentage_return
    return 0.0 if profit==0
    (profit / full_cost) * 100
  end
  
  def profit_loss
    buy_total = trade_logs.sum( 'total', :conditions => ['action=?', 'Buy'] ) * -1
    sell_total = trade_logs.sum( 'total', :conditions => ['action=?', 'Sell'] )
    buy_total + sell_total
  end

  def standard_quote
    @quote ||= YahooFinance::get_quotes YahooFinance::StandardQuote, self.symbol
    @quote[self.symbol]
  end
end
