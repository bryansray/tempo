require File.dirname(__FILE__) + '/../spec_helper'

describe TeamsController, "handling /projects/1/teams/new" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    @team = mock_model(Team, :to_param => 1)
    @teams = [@team]
    
    Project.stub!(:find).and_return(@project)
    Team.stub!(:new).and_return(@team)
  end
  
  def do_get
    get :new, :project_id => 1
  end
  
  it "should create a new team that can be assigned to the view" do
    Team.should_receive(:new).and_return(@team)
    do_get
  end
  
  it "should render the new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should assign the newly built team to the associated view" do
    do_get
    assigns[:team].should == @team
  end
end

describe TeamsController, "handling POST /projects/1/teams" do
  before(:each) do
    @team = mock_model(Team, :to_param => 1)
    @project = mock_model(Project, :to_param => 1)
    Team.stub!(:new).and_return(@team)
    Project.stub!(:find).and_return(@project)
    @team.stub!(:project=).and_return(@project)
  end
  
  def do_post
    post :create, :project_id => 1, :team => {}
  end
  
  def post_with_successful_save
    @team.should_receive(:save).and_return(true)
    do_post
  end
  
  def post_with_unsuccessful_save
    @team.should_receive(:save).and_return(false)
    do_post
  end
  
  it "should find the project that this team should be assigned to" do
    Project.should_receive(:find).and_return(@project)
    post_with_successful_save
  end
  
  it "should assign the newly created team to the project that is passed in" do
    @team.should_receive(:project=).and_return(@project)
    post_with_successful_save
  end
  
  it "should redirect to the newly created team after successful save" do
    post_with_successful_save
    response.should redirect_to(project_team_path(@project, @team))
  end
  
  it "should set a flash message letting the user know a team was created" do
    post_with_successful_save
    flash[:notice].should_not be_nil
  end
  
  it "should render the new template again on a failed save" do
    post_with_unsuccessful_save
    response.should render_template('new')
  end
end