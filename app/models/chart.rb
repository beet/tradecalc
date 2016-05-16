class Chart < ActiveRecord::Base
  belongs_to :trade_calculation
  serialize :moving_averages
  serialize :exponential_moving_averages
  serialize :indicators
  serialize :chart_overlays
  
  def url
    chart_params = self.attributes.dup

    %w(moving_averages exponential_moving_averages indicators chart_overlays).each do |method|
      chart_params[method].keep_if { |key, value| value == "true" }
    end

    chart_params.merge!( 'symbol' => self.trade_calculation.symbol )
    YahooFinanceCharts::Base.new( chart_params ).url
  end

  def checkbox_selected?(attribute, name)
    send(attribute).keep_if { |key, value| value == "true" }
      .keys
      .include?(name)
  end
end
