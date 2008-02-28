require File.dirname(__FILE__) + '/../spec_helper'

describe HomesController, "#routes_for" do
  it "should map { :controller => 'homes', :action => 'show' } to /home" do
    route_for(:controller => "homes", :action => "show").should == "/home"
  end
end

describe HomesController, "handling GET /home" do
  before(:each) do
    @content = mock_model(Content, :to_param => 1, :published => true)
    @link = mock_model(Link, :to_param => 1)
    @visit = mock_model(Visit, :to_param => 1)
    @project = mock_model(Project, :to_param => 1)

    @contents = [@content]
    @links = [@link]
    @visits = [@visit]
    @projects = [@project]
    
    Content.stub!(:find).and_return(@contents)
    Link.stub!(:find).and_return(@links)
    Visit.stub!(:find).and_return(@visits)
    Project.stub!(:find).and_return(@projects)
  end
	
  def do_get
    get :show, :id => 1
  end

  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render the show template" do
    do_get
    response.should render_template("show")
  end
  
  it "should assign an array of visits to the associated view" do
    do_get
    assigns[:visits].should == @visits
  end
  
  it "should assign the projects to the associated view" do
    do_get
    assigns[:projects].should eql(@projects)
  end
  
  it "should assign an array of content to the associated view" do
    do_get
    assigns[:contents].should eql(@contents)
  end

  it "should assign an array of links to the associated view" do
    do_get
    assigns[:links].should == @links
  end

  it "should find a list of links" do
    Link.should_receive(:find).and_return(@links)
    do_get
  end

  it "should find an array of content that is in the system" do
    Content.should_receive(:find).and_return(@contents)
    do_get
  end
  
  it "should find a list of views that have been found" do
    Visit.should_receive(:find).and_return(@visits)
    do_get
  end
  
  it "should find the list of all the projects" do
    Project.should_receive(:find).and_return(@projects)
    do_get
  end

end
