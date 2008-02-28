require File.dirname(__FILE__) + '/../spec_helper'

describe CardTypesController, "#routes_for" do
  it "should map { :controller => 'card_types', :action => 'show', :id => 1, :project_id => 1 } to /projects/1/card_types/1" do
    route_for(:controller => "card_types", :action => "show", :id => 1, :project_id => 1).should == "/projects/1/card_types/1"
  end
  
  it "should map { :controller => 'card_types', :action => 'index', :project_id => 1 } to /projects/1/card_types" do
    route_for(:controller => 'card_types', :action => 'index', :project_id => 1).should == "/projects/1/card_types"
  end
  
  it "should map { :controller => 'card_types', :action => 'create', :project_id => 1 } to /projects/1/card_types" do
    route_for(:controller => "card_types", :action => "index", :project_id => 1).should == "/projects/1/card_types"
  end
end

describe CardTypesController, "handling GET /projects/1/card_types" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    @card_type = mock_model(CardType, :to_param => 1)
    
    Project.stub!(:find).and_return(@project)
  end
  
  def do_get
    get :index, :project_id => 1
  end

  it "GET 'index' should be successful" do
    do_get
    response.should be_success
  end
  
  it "should assign the proejct to the view" do
    do_get
    assigns[:project].should == @project
  end
end

describe CardTypesController, "handling GET /projects/1/card_types/1" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
  end
  def do_get
    get :show, :project_id => 1, :id => 1
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
end

describe CardTypesController, "handling GET/projects/1/card_types/1/edit" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    @card_type = mock_model(Type, :to_param => 1)
    Project.stub!(:find).and_return(@project)
    Type.stub!(:find).and_return(@card_type)
  end
  
  def do_get
    get :edit, :project_id => 1, :id => 1
  end
  
  it "should assign the request card type to the view" do
    do_get
    assigns[:card_type] == @card_type
  end
end

describe CardTypesController, "handling GET /projects/1/card_types/new" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    @card_type = mock_model(CardType, :to_param => 1)
    Project.stub!(:find).and_return(@project)
    Type.stub!(:new).and_return(@card_type)
  end
  
  def do_get
    get :new, :project_id => 1
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should create a new card type" do
    Type.should_receive(:new).and_return(@card_type)
    do_get
  end
  
  it "should assign the card_type to the view" do
    do_get
    assigns[:card_type].should eql(@card_type)
  end
end

describe CardTypesController, "handling POST /projects/1/card_types" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    @card_type = mock_model(CardType, :to_param => 1)
    @card_types = [@card_type]
    
    Project.stub!(:find).and_return(@project)
    @project.stub!(:card_types).and_return(@card_types)
    @card_types.stub!(:build).and_return(@card_type)
  end
  
  def do_post
    post :create, :card_type => {}, :project_id => 1
  end
  
  def post_with_successful_save
    @card_type.should_receive(:save).and_return(true)
    do_post
  end
  
  def post_with_failed_save
    @card_type.should_receive(:save).and_return(false)
    do_post
  end
  
  it "should find the specified project" do
    Project.should_receive(:find).with("1").and_return(@project)
    post_with_successful_save
  end
  
  it "should build a new card type for the project" do
    @project.should_receive(:card_types).and_return(@card_types)
    @card_types.should_receive(:build).with(anything).and_return(@card_type)
    post_with_successful_save
  end
  
  it "should redirect to the card type that was created on successful save" do
    post_with_successful_save
    response.should redirect_to(project_card_types_path)
  end
  
  it "should populate the flash notice on a successful save" do
    post_with_successful_save
    flash[:notice].should_not be_nil
  end
end