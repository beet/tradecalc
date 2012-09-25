class TradeCalculationsController < ApplicationController
  before_filter :login_required
  # before_filter :find_member, :except => [:update_calculation_form]
  
  def index
    @trade_calculations = @current_member.trade_calculations.find :all
  end

  def new
    @trade_calculation ||= @current_member.trade_calculations.build params[:trade_calculation]
  end

  def create
    @trade_calculation = @current_member.trade_calculations.create params[:trade_calculation]
    if @trade_calculation.errors.empty?
      message = "Your trade calculation has been created."
      if @current_member.trade_calculations.count==1
        path = new_member_trade_calculation_trade_log_path(:member_id => @current_member, :trade_calculation_id => @trade_calculation)
        message << " Let's get started with your first trade log for #{@trade_calculation.name}"
      else
        path = {:action => 'index'}
      end
      flash[:notice] = message
      redirect_to path and return false
    end
    render :action => 'new'
  end
  
  def show
    find_trade_calculation
  end

  def edit
    find_trade_calculation
  end

  def update
    find_trade_calculation
    @trade_calculation.update_attributes params[:trade_calculation]
    if @trade_calculation.errors.empty?
      flash[:notice] = "Your trade calculation has been updated."
      redirect_to member_trade_calculation_url(:member_id => @current_member, :id => @trade_calculation) and return false
    end
    render :action => 'edit'
  end

  def destroy
    if trade_calculation = @current_member.trade_calculations.find( params[:id] )
      trade_calculation.destroy
      flash[:notice] = "Your trade calculation has been deleted."
      redirect_to :action => 'index'
    end
  end
  
  def update_calculation_form
    @trade_calculation = TradeCalculation.new params[:trade_calculation]
    render :layout => false
  end
  
  def show_latest_quote
    find_trade_calculation
  end
  
  def set_purchase_price_to_quote
    symbol = params[:symbol]
    @purchase_price = quote_for_symbol( symbol )
  end
  
  def set_sale_price_to_quote
    symbol = params[:symbol]
    @sale_price = quote_for_symbol( symbol )
  end

  private
  
    def find_trade_calculation
      @trade_calculation ||= @current_member.trade_calculations.find( params[:id], :include => [:trade_logs] )
    end
    
end
