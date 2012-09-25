require 'spec_helper'

describe Chart do
  before(:each) do
    @valid_attributes = {
      :range => "value for range",
      :type => "value for type",
      :size => "value for size",
      :moving_averages => "value for moving_averages",
      :exponential_moving_averages => "value for exponential_moving_averages",
      :indicators => "value for indicators",
      :chart_overlays => "value for chart_overlays"
    }
  end

  it "should create a new instance given valid attributes" do
    Chart.create!(@valid_attributes)
  end
end
