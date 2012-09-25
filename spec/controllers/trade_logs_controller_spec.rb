require 'spec_helper'

describe TradeLogsController do
  fixtures :members, :trade_calculations, :trade_logs
  before(:each) do
    @params = {:member_id => 1, :trade_calculation_id => 1}
  end

  #Delete these examples and add some real ones
  it "should use TradeLogsController" do
    controller.should be_an_instance_of(TradeLogsController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index', @params
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new', @params
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      @params[:id] = 1
      get 'edit', @params
      response.should be_success
    end
  end
end
