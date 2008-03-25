# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper
  
  def link_to_window(name, window_title, ext_options, html_options = {})
    options = []
    options << "win = new Ext.Window({ title: '#{window_title}', #{ext_options} }); win.show(this)"
    
    link_to_function(name, options, html_options)
  end
  
  def format_filename( name, len = 20 )
    ext_len = name.reverse.index(".") #extension length
    ext_len = 0 if ext_len.nil?     #no ext
    period_idx = (name.length - ext_len - 1) #gets the index of the last '.' char
    ext = name[period_idx+1,ext_len] #get the ext name
    file = name[0..period_idx-1] #get the file name w/out the ext"
    #print file << "\n\n"
    #if the length is more than len, clip the name, otherwise return the original value
    if file.length > len
        return file[0..len-1]<<"...."<<ext
    else
        return name
    end
  end
  
  def burndown_chart( iteration, options = {}, html_options = {} )
    return "" if iteration.nil?
  	options[:width] ||= 300
  	options[:height] ||= 200
  	options[:type] ||= :linexy
  	options[:google_chart_options] = "chls=3,1,0|2,4,2&amp;chco=ff0000,c0c0c0&amp;chtt=Burndown+for+#{iteration.team.title.gsub(" ", "+")}|#{iteration.to_s.gsub(" ", "+")}"
	
    html_options[:alt] ||= "Burndown chart for '#{iteration.team.title}' team"
	
    image_tag GoogleChart.build_url( 
      options[:width], 
      options[:height], 
      [[0,iteration.day_of],[iteration.real_hours,iteration.remaining_hours],[],[iteration.card_hours,0]], 
      options[:type], 
      iteration.days, 
      [iteration.card_hours,iteration.real_hours].max,
      options),
      html_options
  end
  
  def prettify_history_hash( detail )
  	idx = detail[0].index("_id")
  	return detail if idx.nil?
  	model_name = detail[0][0..idx-1].capitalize
  	model_old = ""
  	model_new = ""
  	eval "model_old = #{model_name}.find(detail[1][0])" if (!detail[1][0].nil? && detail[1][0] > 0)
  	eval "model_new = #{model_name}.find(detail[1][1])" if (!detail[1][1].nil? && detail[1][1] > 0)
  	return [ model_name,[model_old.to_s,model_new.to_s] ]
  end
  
  #Creates link and textbox elements for a given object and field that can be toggled and updated via Ajax.
  def generic_update_textbox( object, field, options = {} )
    #get instance of referenced field for use later
    field_obj = object.send(field)
    
    #the options hash will be passed to the form field...we are setting some needed defaults here
    options[:size] = 4 if options[:size].nil?
    options[:style] = "" if options[:style].nil?
    options[:style] << "display: none;"
    
    #This is what to display when a null value is encountered
    null_text = "(not set)"
    
    #this is the url to post the update to
    url = url_for :action => "generic_field_updater", :id => object.id
    
    #this is the html id attribute values to be used for the link and form field
    link_id = "#{object.class}_#{field}_#{object.id}_link"
    text_id = "#{object.class}_#{field}_#{object.id}_text"
    
    link_text = field_obj.nil? ? null_text : field_obj.to_s
    
    #ok, everything is set, time to build the html
    out = link_to( link_text, '#', :id => link_id )
	  out << text_field_tag( text_id, field_obj, options )
    out << observe_generic_update_fields( text_id, link_id, :url => url, :with => "'field=#{field}&model=#{object.class}&value=' + value", :null_text => null_text)
  end
  
  #Creates link and select elements for a given model and field that can be toggled and updated via Ajax.
  def generic_update_select( object, field, option_list = nil, options = {} )
    #get instance of referenced field for use later
    field_obj = object.send(field)
    
    #the options hash will be passed to the form field...we are setting some needed defaults here
    options[:style] = "" if options[:style].nil?
    options[:style] << "display: none;"
    
    #This is what to display when a null value is encountered
    null_text = "(not set)"
    
    #this is the url to post the update to
    url = url_for :action => "generic_field_updater", :id => object.id
    
    #this is the html id attribute values to be used for the link and form field
    link_id = "#{object.class}_#{field}_id_#{object.id}_link"
    text_id = "#{object.class}_#{field}_id_#{object.id}_text"
    
    link_text = field_obj.nil? ? null_text : field_obj.to_s
    
    #build the options list for our select tag if it wasn't given to us
    if option_list.nil?
      #TODO: this probably shouldn't get ALL the models
      list = nil
      eval "list = #{field_obj.class}.find(:all)"
      
      #this creates an option to represent a null value
      option_list = options_for_select( [[null_text, -1]], field_obj.nil? ? -1 : 0)
      #this creates the list of assignable values
      option_list << options_for_select( list.collect { |item| [item.to_s, item.id] }, field_obj.id )
    end
    
    #ok, everything is set, time to build the html
    out = link_to( link_text, '#', :id => link_id )
	  out << select_tag( text_id, option_list, options )
    out << observe_generic_update_fields( text_id, link_id, :url => url, :with => "'field=#{field}_id&model=#{object.class}&value=' + value", :null_text => null_text)
  end
  
  #This will create a new PropertySetter instance that will make an Ajax request by default. If you pass a :function option, then it will use that specified JS function.
  #The PropertySetter object expects a link element and a textbox element to passed to it.
  def observe_generic_update_fields(field_id, link_id, options = {})
    #defines what is considered a null value
    null_text = options[:null_text] || ""
    ps_instance = "ps_" + field_id # a unique name to refer to the instance of the PropertySetter object that will be created
                                   # we will use this as part of the onSuccess call back in the Ajax request
    
    options[:success] = "#{ps_instance}.success(request)"
    
    #by default, we make an Ajax request using the built-in rails/prototype helper
    callback = options[:function] || remote_function(options)
    
    javascript = "var #{ps_instance} = new PropertySetter('#{field_id}', '#{link_id}', "
    javascript << "function(element, value) {"
    javascript << "#{callback}}"
    javascript << ", '#{null_text}');"
    
    javascript_tag(javascript)
  end
end