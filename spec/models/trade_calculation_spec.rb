require 'spec_helper'

describe TradeCalculation do
  before(:each) do
    @valid_attributes = {
      :member_id => 1,
      :name => "value for name",
      :symbol => 'value for symbol',
      :description => "value for description",
      :units => 1,
      :purchase_price => 1.5,
      :stop_loss_exit_price => 1.5,
      :target_sale_price => 1.5
    }
  end

  it "should create a new instance given valid attributes" do
    TradeCalculation.create!(@valid_attributes)
  end
  
  it "should calculate the full cost" do
    trade_calculation = TradeCalculation.new :units => 7, :purchase_price => 123.45
    trade_calculation.full_cost.should == trade_calculation.units * trade_calculation.purchase_price
  end
  it "should calculate the risk amount" do
    trade_calculation = TradeCalculation.new :units => 12, :purchase_price => 123.45, :stop_loss_exit_price => 120.00
    trade_calculation.risk.should == (trade_calculation.full_cost - (trade_calculation.units * trade_calculation.stop_loss_exit_price))
  end
  it "should calculate the total return" do
    trade_calculation = TradeCalculation.new :units => 12, :target_sale_price => 234.56
    trade_calculation.total_return.should == trade_calculation.units * trade_calculation.target_sale_price
  end
  it "should calculate the profit amount" do
    trade_calculation = TradeCalculation.new :units => 5, :purchase_price => 123.45, :target_sale_price => 234.56
    trade_calculation.profit.should == trade_calculation.total_return - trade_calculation.full_cost
  end
  it "should calculate the % return" do
    trade_calculation = TradeCalculation.new :units => 5, :purchase_price => 123.45, :target_sale_price => 234.56
    profit = trade_calculation.profit
    trade_calculation.percentage_return.should == ((trade_calculation.profit / trade_calculation.full_cost) * 100)
  end
  
  describe "when calculating profit/loss" do
    fixtures :members, :trade_calculations
    before(:each) do
      @trade_calculation = TradeCalculation.find :first
    end
    it "should subtract the sum of all Buy trade log entries to the total" do
      log_data = [  {:action => 'Buy', :units => 1, :price => 4557, :date => Time.now},
                    {:action => 'Buy', :units => 1, :price => 4560, :date => Time.now},
                    {:action => 'Buy', :units => 1, :price => 4593, :date => Time.now} ]
      total = log_data.sum {|d| d[:price]} * -1
      log_data.each do |attributes|
        @trade_calculation.trade_logs.build attributes
      end
      @trade_calculation.save!
      @trade_calculation.profit_loss.should == total
    end
    it "should add the sum of all Sell trade log entries from the total" do
      log_data = [  {:action => 'Sell', :units => 1, :price => 4560, :date => Time.now},
                    {:action => 'Sell', :units => 1, :price => 4553, :date => Time.now},
                    {:action => 'Sell', :units => 1, :price => 4587, :date => Time.now} ]
      total = log_data.sum {|d| d[:price]}
      log_data.each do |attributes|
        @trade_calculation.trade_logs.build attributes
      end
      @trade_calculation.save!
      @trade_calculation.profit_loss.should == total
    end
    it "should combine the sum of all Buy/Sell trade log entries" do
      log_data = [  {:action => 'Buy', :units => 1, :price => 4557, :date => Time.now},
                    {:action => 'Buy', :units => 1, :price => 4560, :date => Time.now},
                    {:action => 'Buy', :units => 1, :price => 4593, :date => Time.now} ]
      buy_total = log_data.sum {|d| d[:price]} * -1
      log_data.each do |attributes|
        @trade_calculation.trade_logs.build attributes
      end
      log_data = [  {:action => 'Sell', :units => 1, :price => 4560, :date => Time.now},
                    {:action => 'Sell', :units => 1, :price => 4553, :date => Time.now},
                    {:action => 'Sell', :units => 1, :price => 4587, :date => Time.now} ]
      sell_total = log_data.sum {|d| d[:price]}
      log_data.each do |attributes|
        @trade_calculation.trade_logs.build attributes
      end
      @trade_calculation.save!
      @trade_calculation.profit_loss.should == buy_total + sell_total
    end
  end
    
  describe "when fetching quotes from Yahoo Finance" do
    before(:all) do
      @trade_calculation = TradeCalculation.new :symbol => 'AAPL'
      @quote = @trade_calculation.standard_quote
    end
    it "should get the open price" do
      @quote.open.should_not be_blank
    end
    it "should get the previous close" do
      @quote.previousClose.should_not be_blank
    end
    it "should get the last trade" do
      @quote.lastTrade.should_not be_blank
    end
    it "should get the low" do
      @quote.dayLow.should_not be_blank
    end
    it "should get the high" do
      @quote.dayHigh.should_not be_blank
    end
  end

end
