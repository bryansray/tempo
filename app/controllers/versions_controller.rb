class VersionsController < ApplicationController

  def index
    #post = Post.find(params[:post_id])
    @content = Content.find(params[:content_id])
    @versions = @content.versions.find(:all, :order => "updated_at DESC")
    
    respond_to do |format|
      format.html { render :template => "versions/index", :layout => false }
      format.js { @versions.to_json }
    end
  end

  def show
  end

  def destroy
  end
end
