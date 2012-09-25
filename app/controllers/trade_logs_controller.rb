class TradeLogsController < ApplicationController
  before_filter :login_required
  before_filter :find_trade_calculation, :except => [:update_calculation_form, :set_price_to_quote]
  
  def index
    @trade_logs = @trade_calculation.trade_logs.find :all
  end

  def new
    @trade_log = @trade_calculation.trade_logs.build( { :units => @trade_calculation.units }.merge( params[:trade_log] || {} ) )
  end
  
  def create
    @trade_log = @trade_calculation.trade_logs.create params[:trade_log]
    if @trade_log.errors.empty?
      flash[:notice] = "Your trade log has been created."
      redirect_to :action => 'index' and return false
    end
    render :action => 'new'
  end
  
  def show
    @trade_log = @trade_calculation.trade_logs.find params[:id]
  end

  def edit
    @trade_log ||= @trade_calculation.trade_logs.find params[:id]
  end
  
  def update
    @trade_log = @trade_calculation.trade_logs.find params[:id]
    if request.put?
      @trade_log.update_attributes params[:trade_log]
      if @trade_log.errors.empty?
        flash[:notice] = "Your trade log entry has been edited."
        redirect_to :action => 'index' and return false
      end
    end
    render :action => 'edit'
  end
  
  def destroy
    @trade_calculation.trade_logs.find(params[:id]).destroy
    flash[:notice] = 'Your trade log entry has been deleted'
    redirect_to :action => 'index' and return false
  end

  def update_calculation_form
    @trade_log = TradeLog.new params[:trade_log]
    @trade_log.calculate_total
    render :layout => false
  end
  
  def set_price_to_quote
    symbol = params[:symbol]
    @price = quote_for_symbol( symbol )
  end

end
