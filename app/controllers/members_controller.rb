class MembersController < ApplicationController  

  def index
    # Redirect to the trade calculations page if a member is currently logged in
    return redirect_to(member_trade_calculations_path(@current_member)) if @current_member.present?
  end

  # render new.rhtml
  def new
    @member = Member.new
  end
 
  def create
    logout_keeping_session!
    @member = Member.new(params[:member])
    success = @member && @member.save
    if success && @member.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_member = @member # !! now logged in
      redirect_back_or_default new_member_trade_calculation_path(@member)
      flash[:notice] = "Thanks for signing up! Let's get started with your first trade calculation:"
    else
      flash.now[:error]  = "We couldn't set up that account, sorry.  Please check the errors below and try again."
      render :action => 'new'
    end
  end

  def edit
    @member ||= Member.find params[:id]
  end

  def update
    @member = Member.find params[:id]
    @member.update_attributes params[:member]
    if @member.errors.empty?
      flash[:notice] = "Your details have been saved"
      redirect_to :action => 'index' and return false
    end
    render :action => 'edit'
  end

end
