class Admin::TaggingsController < ApplicationController
  def destroy
    @tagging = Tagging.find params[:id]
    @tagging.destroy
  end
  
  def update
    puts "--- #{params.inspect}"
    type = params[:tags][:taggable_type].constantize
    @content =  type.find params[:id]
    @content.tag_list.add params[:tags][:tag_list], :parse => true
    
    respond_to do |format|
      if @content.save
        format.js
      end
    end    
  end
  
  def create
    puts "--- #{params.inspect}"
    type = params[:tags][:taggable_type].constantize
    @content =  type.find params[:id]
    @content.tag_list.add params[:tags][:tag_list], :parse => true
    
    respond_to do |format|
      if @content.save
        format.js
      end
    end
  end
end
