require 'spec_helper'

describe TradeLog do
  fixtures :members, :trade_calculations
  before(:each) do
    @valid_attributes = {
      :trade_calculation_id => 1,
      :date => Time.now,
      :action => "value for action",
      :units => 1,
      :price => 1.5,
      :total => 1.5
    }
  end

  it "should create a new instance given valid attributes" do
    TradeLog.create!(@valid_attributes)
  end
  
  it "should pre-calculate and store the total price" do
    member = members(:quentin)
    trade_calculation = member.trade_calculations.first
    trade_log = trade_calculation.trade_logs.create! @valid_attributes
    trade_log.total.should == 1.5
  end
  
  it "should return 0.00 when calcaulting the total price if the units attribute is blank" do
    TradeLog.new( :price => 123.45 ).calculate_total.should == 0.00
  end
  
  it "should return 0.00 when calcaulting the total price if the price attribute is blank" do
    TradeLog.new( :units => 123 ).calculate_total.should == 0.00
  end

end
