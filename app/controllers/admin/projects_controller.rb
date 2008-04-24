class Admin::ProjectsController < ApplicationController
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    
    respond_to do |format|
      format.html { redirect_to(projects_path)}
    end
  end
end
