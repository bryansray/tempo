class Admin::TaggingsController < ApplicationController
  def destroy
    @tagging = Tagging.find params[:id]
    @object = @tagging.taggable
    @tagging.destroy
  end
  
  def update    
  end
  
  def create
    type = params[:applicator][:class].constantize
    @object = type.find params[:applicator][:id]
    @object.tag_list.add params[:tag][:name], :parse => true
    
    respond_to do |format|
      if @object.save_tags
        format.js
      end
    end
  end
end
