class Chart < ActiveRecord::Base
  belongs_to :trade_calculation
  serialize :moving_averages
  serialize :exponential_moving_averages
  serialize :indicators
  serialize :chart_overlays
  # before_save :process_checkbox_fields
  
  # Nasty, should really pull in the YahooFinanceCharts module as a plugin
  def url
    chart_params = self.attributes.merge( 'symbol' => self.trade_calculation.symbol )
    # moving_averages_param = {}
    # exponential_moving_averages_param = {}
    # indicators_param = {}
    # chart_overlays_param = {}
    # self.moving_averages.each {|key| moving_averages_param[key] = true}
    # self.exponential_moving_averages.each {|key| exponential_moving_averages_param[key] = true}
    # self.indicators.each {|key| indicators_param[key] = true}
    # self.chart_overlays.each {|key| chart_overlays_param[key] = true}
    # chart_params['moving_averages'] = moving_averages_param
    # chart_params['exponential_moving_averages'] = exponential_moving_averages_param
    # chart_params['indicators'] = indicators_param
    # chart_params['chart_overlays'] = chart_overlays_param
    YahooFinanceCharts::Base.new( chart_params ).url
  end

  private
  
    # The YahooFinanceCharts modue was expecting to receive form parameters from checkboxes as a hash
    def process_checkbox_fields
      %w(moving_averages exponential_moving_averages indicators chart_overlays).each do |field_name|
        value = self.send(field_name)
        next if value.blank?
        self.send(field_name + '=', value.keys)
      end
    end

end
