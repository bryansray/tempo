class HomesController < ApplicationController
  def index
    @contents = Content.find(:all, :limit => 10, :order => "published_at DESC")
  end
  
  def show
    @contents = Content.find(:all, :conditions => ["published = ?", true], :limit => 10, :order => "updated_at DESC")
    @links = Link.find(:all, :order => "position", :limit => 5)
    @visits = Visit.find(:all, :select => "id, user_id, content_id, count(*) as 'count'", :limit => 10, :group => "user_id, content_id", :order => "MAX(created_at) DESC")
    @projects = Project.find(:all)
  end
end
