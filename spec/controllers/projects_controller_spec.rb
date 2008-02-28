require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsController, "#route_for" do
  it "should map { :controller => 'projects', :action => 'index' } to /projects" do
    route_for(:controller => "projects", :action => "index").should == "/projects"
  end

  it "should map { :controller => 'projects', :action => 'show', :id => 1 } to /projects/1" do
    route_for(:controller => "projects", :action => "show", :id => 1).should == "/projects/1"
  end
  
  it "should map { :controller => 'projects', :action => 'edit', :id => 1 ) to /projects/1/edit" do
    route_for(:controller => "projects", :action => "edit", :id => 1).should == "/projects/1/edit"
  end
  
  it "should map { :controller => 'projects', :action => 'new', :id => 1 ) to /projects/new" do
    route_for(:controller => "projects", :action => "new").should == "/projects/new"
  end
  
  it "should map { :controller => 'projects', :action => 'create' ) to /projects/1" do
    route_for(:controller => "projects", :action => "create").should == "/projects"
  end
  
  it "should map { :controller => 'projects', :action => 'update', :id => 1 ) to /projects/1" do
    route_for(:controller => "projects", :action => "update", :id => 1).should == "/projects/1"
  end
  
  it "should map { :controller => 'projects', :action => 'destroy', :id => 1 ) to /projects/1" do
    route_for(:controller => "projects", :action => "destroy", :id => 1).should == "/projects/1"
  end
end

describe ProjectsController, "handlng GET /projects" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    @team = mock_model(Team, :to_param => 1)
    
    @projects = [@project]
    @teams = [@team]
    
    Project.stub!(:find).and_return(@projects)
    Team.stub!(:find).and_return(@teams)
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render the index template" do
    do_get
    response.should render_template("index")
  end
  
  it "should find all the projects" do
    Project.should_receive(:find).with(:all).and_return(@projects)
    do_get
  end
  
  it "should find all the teams to display" do
    Team.should_receive(:find).with(:all).and_return(@teams)
    do_get
  end
  
  it "should assign all the projects to the associated view" do
    do_get
    assigns[:projects].should eql(@projects)
  end
  
  it "should assign all the teams to the associated view" do
    do_get
    assigns[:teams].should eql(@teams)
  end
end

describe ProjectsController, "handling GET /projects/1" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    
    Project.stub!(:find).and_return(@project)
  end
  
  def do_get
    get :show, :id => 1
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the requested project" do
    Project.should_receive(:find).with("1").and_return(@project)
    do_get
  end
  
  it "should assign the project to associated view" do
    do_get
    assigns[:project].should eql(@project)
  end
  
  it "should render the show template" do
    do_get
    response.should render_template("show")
  end  
end

describe ProjectsController, "handling GET /projects/new" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    Project.stub!(:new).and_return(@project)
  end
  
  def do_get
    get :new
  end
  
  it "should render the new template" do
    do_get
    response.should render_template("new")
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should create a new project that will be assigned to the view" do
    Project.should_receive(:new).and_return(@project)
    do_get
  end
  
  it "should assign the newly created project to the associated view" do
    do_get
    assigns[:project].should eql(@project)
  end
end

describe ProjectsController, "handling POST /projects" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    Project.stub!(:new).and_return(@project)
  end
  
  def do_post
    post :create, :project => {}
  end
  
  def post_with_successful_save
    @project.should_receive(:save).and_return(true)
    do_post
  end
  
  def post_with_unsuccessful_save
    @project.should_receive(:save).and_return(false)
    do_post
  end
  
  it "should create a new project" do
    Project.should_receive(:new).and_return(@project)
    post_with_successful_save
  end
  
  it "should redirect to the new project on successful save" do
    post_with_successful_save
    response.should redirect_to(project_path(@project))
  end
  
  it "should re-render the new template if it fails to create the project" do
    post_with_unsuccessful_save
    response.should render_template("new")
  end
end