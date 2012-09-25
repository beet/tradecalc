require 'spec_helper'

describe TradeCalculationsController do
  before(:each) do
    @params = {:member_id => 1}
  end

  #Delete these examples and add some real ones
  it "should use TradeCalculationsController" do
    controller.should be_an_instance_of(TradeCalculationsController)
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

  describe "GET 'create'" do
    it "should be successful" do
      get 'create', @params
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

  describe "POST 'update'" do
    it "should be successful" do
      @params[:id] = 1
      post 'update', @params
      response.should be_redirect
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      @params[:id] = 1
      get 'destroy', @params
      response.should be_redirect
    end
  end
end
