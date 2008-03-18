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
		options), html_options
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
  
end