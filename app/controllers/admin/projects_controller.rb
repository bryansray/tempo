class Admin::ProjectsController < ApplicationController
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    
    respond_to do |format|
      format.html { redirect_to(projects_path)}
    end
  end

  def update_tags
    @project = Project.find(params[:id])
    @project.tag_list.remove(Tag.find(params[:tag_id]).name) if params[:tag_id]
    @project.tag_list.add(params[:tags][:tag_list], :parse => true) if params[:tags]
    
    respond_to do |format|
      if @project.save
        format.js
      else
        format.js { render :text => "error" }
      end
    end
  end
end
