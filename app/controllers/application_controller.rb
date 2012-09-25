# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotification::Notifiable
  include AuthenticatedSystem
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter :set_page_title, :find_current_member

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def find_member
    @member = Member.find params[:member_id]
  end
  
  def find_current_member
    @current_member = self.current_member
  end
  
  def set_page_title
    @page_title ||= 'Trading Calculations'
  end

  def find_trade_calculation
    find_member
    @trade_calculation = @current_member.trade_calculations.find params[:trade_calculation_id], :include => [:trade_logs]
  end

  def quote_for_symbol( symbol )
    quote = YahooFinance::get_quotes YahooFinance::StandardQuote, symbol
    quote[symbol].lastTrade
  end

end
