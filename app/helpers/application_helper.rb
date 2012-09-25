# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def render_side_column
    render :partial => "#{params[:controller]}/side_column"
  end
  
  def color_if(do_color, color, &block)
    yield and return unless do_color
    concat "<span class=\"color.#{color.to_s}\">"
    yield
    concat "</span>"
  end
  
  def sidebar_add_button( link_text, url )
    return if params[:action]=='new'
    link_text = "<span>#{link_text}</span>"
    "<p id=\"btn-create\" class=\"box\">#{ link_to link_text, url }</p>"
  end
  
  def sidebar_menu_active( item )
    active = ' id="submenu-active"'
    case item
    when 'trade_calculations'
      return active if params[:controller]=='trade_calculations'
    when 'trade_logs'
      return active if params[:controller]=='trade_logs'
    end
  end
  
  def menu_active( item )
    active = ' id="menu-active"'
    case item
    when 'home'
      return active if params[:controller]=='members'
    when 'trade_calculations'
      return active if params[:controller]=='trade_calculations'
    when 'trade_logs'
      return active if params[:controller]=='trade_logs'
    end
  end
  
  def chart_link( trade_calculation )
    return if trade_calculation.chart.blank?
    link_to image_tag( trade_calculation.chart.url, :width => '200' ), member_trade_calculation_charts_path(:member_id => @current_member, :trade_calculation_id => trade_calculation), {:target => "_charts_#{trade_calculation.id}", :title => "View charts for #{trade_calculation.name}"}
  end

end
