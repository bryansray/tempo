# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base	
  uses_tiny_mce(
  	:options => {
      :apply_source_formatting => true,
      :convert_urls => true,
      :tab_focus => ":prev, :next",
      :cleanup => false,
      :editor_selector => "editor",
      :mode => "textareas",
      :remove_linebreaks => false,
  		:theme => "advanced",
	  	:theme_advanced_toolbar_location => "top",
	  	:theme_advanced_disable => "styleselect, formatselect, image",
	  	:theme_advanced_toolbar_align => "left",
	  	:theme_advanced_resizing => true,
      :plugins => "table, autosave, inlinepopups",
      :theme_advanced_buttons3_add => "tablecontrols",
      :table_styles => "Header 1=header1;Header 2=header2;Header 3=header3",
      :table_cell_styles => "Header 1=header1;Header 2=header2;Header 3=header3;Table Cell=tableCel1",
      :table_row_styles => "Header 1=header1;Header 2=header2;Header 3=header3;Table Row=tableRow1",
      :table_cell_limit => 100
  	}
  )

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  include ExceptionNotifiable
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '7d7f8b106bd55943658e09cec4cf106e'
  
  audit Card, CardProperty, Member
  
  # This action supports the generic_field helpers
  def generic_field_updater
    obj = nil
    eval "obj = #{params[:model]}.find(params[:id])"
    
    if obj.update_attribute( params[:field], params[:value] )
      render :json => { :success => true }
    else
      render :json => { :success => false }
    end
  end
  
  protected
  def rescue_action_in_public(exception)
    puts exception
  	if exception.is_a? ActiveRecord::RecordNotFound
  		render :file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found"
  	else
  		super
  	end
  end
  
  #def rescue_action_locally(e); rescue_action_in_public(e); end
end