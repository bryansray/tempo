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