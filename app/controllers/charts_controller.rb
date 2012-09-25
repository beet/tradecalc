class ChartsController < ApplicationController
  before_filter :login_required
  before_filter :find_trade_calculation
  layout 'charts'
  
  def index
    @chart = @trade_calculation.chart || @trade_calculation.build_chart( default_chart_options )
  end
  
  def create
    @chart = @trade_calculation.create_chart default_chart_options.merge( params[:chart] )
    return process_chart_status
  end
  
  def update
    @chart = @trade_calculation.chart
    @chart.update_attributes params[:chart]
    return process_chart_status
  end
  
  private
  
    def default_chart_options
      { 'size' => 'l', 'chart_type' => 'b', 'range' => '3m', 'moving_averages' => [], 'exponential_moving_averages' => [], 'indicators' => [], 'chart_overlays' => [] }
    end
    
    def process_chart_status
      if @chart.errors.empty?
        flash[:notice] = "Your chart settings for #{@trade_calculation.name} have been saved"
      else
        flash[:error] = "Sorry, there was an error saving your chart settings for #{@trade_calculation.name}"
      end
      return redirect_to :action => 'index'
    end
  
end
