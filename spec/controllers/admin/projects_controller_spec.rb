require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ProjectsController, "#route_for" do
  it "should map { :controller => 'admin/projects', :action => 'index' } to /admin/projects" do
    route_for(:controller => "admin/projects", :action => "index").should == "/admin/projects"
  end
  
  it "should map { :controller => 'admin/projects', :action => 'edit', :id => 1 } to /admin/projects/1/edit" do
    route_for(:controller => "admin/projects", :action => "edit", :id => 1).should == "/admin/projects/1/edit"
  end
  
  it "should map { :controller => 'admin/projects', :action => 'update', :id => 1 } to /admin/projects/1" do
    route_for(:controller => "admin/projects", :action => "update", :id => 1).should == "/admin/projects/1"
  end
  
  it "should map { :controller => 'admin/projects', :action => 'destroy', :id => 1 } to /admin/projects/1" do
    route_for(:controller => "admin/projects", :action => "destroy", :id => 1).should == "/admin/projects/1"
  end
  
  it "should map { :controller => 'admin/projects', :action => 'update_tags', :id => 1 } to /admin/projects/1/update_tags" do
    route_for(:controller => 'admin/projects', :action => 'update_tags', :id => 1).should == "/admin/projects/1/update_tags"
  end
end

describe Admin::ProjectsController, "handling PUT /admin/projects/1/update_tags" do
  before(:each) do
    @tag_list = mock_model(TagList)
    @project = mock_model(Project, :to_param => 1, :tag_list => @tag_list)
    
    Project.stub!(:find).and_return(@project)
    @tag_list.stub!(:add).with({}, :parse => true).and_return(@tag_list)
  end
  
  def do_put
    put :update_tags, :id => 1, :tags => { :tag_list => {} }
  end
  
  def put_with_successful_save
    @project.should_receive(:save).and_return(true)
    do_put
  end
  
  it "should be successful" do
    put_with_successful_save
    response.should be_success
  end
  
  it "should clear out the list of tags that do not belong any longer"
  it "should add in the tags that are passed to the action" do
    @tag_list.should_receive(:add).with({}, :parse => true)
    put_with_successful_save
  end
end

describe Admin::ProjectsController, "handling DELETE /projects/1" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    Project.stub!(:find).and_return(@project)
    @project.stub!(:destroy)
  end
  
  def do_delete
    delete :destroy, :id => 1
  end
  
  it "should find the project that was requested" do
    Project.should_receive(:find).and_return(@project)
    do_delete
  end
  
  it "should call destroy on the project that was found" do
    @project.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the index view for projects" do
    do_delete
    response.should redirect_to(projects_path)
  end
  
end