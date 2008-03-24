require File.dirname(__FILE__) + '/../spec_helper'

describe CardsController, "#route_for" do
  
  it "should map { :controller => 'cards', :action => 'index', :project_id => 1 } to /projects/1/cards" do
    route_for( :controller => "cards", :action => "index", :project_id => 1).should == "/projects/1/cards"
  end
  
  it "should map { :controller => 'cards', :action => 'edit', :project_id => 1 } to /projects/1/cards/1/edit" do
    route_for( :controller => "cards", :action => "edit", :id => 1, :project_id => 1).should == "/projects/1/cards/1/edit"
  end
  
  it "should map { :controller => 'cards', :action => 'new', :project_id => 1 } to /projects/1/cards/new" do
    route_for( :controller => "cards", :action => "new", :project_id => 1 ).should == "/projects/1/cards/new"
  end
  
  it "should map { :controller => 'cards', :action => 'show', :id => 1, :project_id => 1 } to /projects/1/cards/1" do
    route_for( :controller => "cards", :action => "show", :id => 1, :project_id => 1).should == "/projects/1/cards/1"
  end
  
  it "should map { :controller => 'cards', :action => 'destroy', :id => 1, :project_id => 1 } to /projects/1/cards/1" do
    route_for(:controller => "cards", :action => "destroy", :id => 1, :project_id => 1).should == "/projects/1/cards/1"
  end
  
  it "should map { :controller => 'cards', :action => 'index', :team_id => 1 } to /teams/1/cards" do
    route_for(:controller => "cards", :action => "index", :team_id => 1).should == "/teams/1/cards"
  end
  
  it "should map { :controller => 'cards', :action => 'generic_field_updaters', :id => 1 } to /cards/generic_field_updaters/1" do
    route_for(:controller => "cards", :action => "generic_field_updaters", :id => 1).should == "/cards/generic_field_updaters/1"
  end    
end

describe CardsController, "handling GET /cards" do
  before(:each) do
    @card = mock_model(Card, :to_param => 1)    
    @cards = [@card]
  end
  
  describe "when listing all the cards for a specific team" do
    before(:each) do
      @team = mock_model(Team, :to_param => 1)
      @project = mock_model(Project, :to_param => 1)
      
      Team.stub!(:find).and_return(@team)
      @team.stub!(:project).and_return(@project)
    end
    
    def do_get
      get :index, :team_id => 1
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should find the team that we want to display cards for" do
      Team.should_receive(:find).and_return(@team)
      do_get
    end
    
    it "should set the project the team is associated with to the requesting view" do
      do_get
      assigns[:project].should == @project
    end
    
    it "should assign the team to the associated view" do
      do_get
      assigns[:team].should == @team
    end
  end
  
  describe "when listing all the cards for a project" do
    before(:each) do
      @project = mock_model(Project, :to_param => 1)
      Project.stub!(:find).and_return(@project)
    end
    
    def do_get
      get :index, :project_id => 1
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should find the project to list the cards for" do
      Project.should_receive(:find).and_return(@project)
      do_get
    end
    
    it "should assign the project to the specified view" do
      do_get
      assigns[:project].should eql(@project)
    end
  end

  
  describe "when a property_id is NOT specified to group by" do
    before(:each) do
      @property = mock_model(Property, :to_param => 1, :name => "Status")
      @option = mock_model(Option, :to_param => 1)
      @options = [@option]
      
      @property.stub!(:options).and_return(@options)
    end
    
    def do_get
      get :index, :property_id => 1, :project_id => 1
    end
  end
  
  describe "when a property_id is specified to group by" do
    before(:each) do
      
    end
  end
end

describe CardsController, "handling GET /projects/1/cards/1" do
  before(:each) do
    @card = mock_model(Card, :to_param => 1)
    Card.stub!(:find_by_number).and_return(@card)
  end
  
  def do_get
    get :show, :project_id => 1, :id => 1
  end
  
  it "should find the requested card by the number and project id" do
    Card.should_receive(:find_by_number).and_return(@card)
    do_get
  end
  
  it "should assign the card to the associated view" do
    do_get
    assigns[:card].should == @card
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
end

describe CardsController, "handling POST /teams/1/cards" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    @team = mock_model(Team, :to_param => 1)
    @card = mock_model(Card, :to_param => 1)
    
    Project.stub!(:find).and_return(@project)
    Card.stub!(:new).and_return(@card)
    Team.stub!(:find).and_return(@team)
    @card.stub!(:team=).and_return(@team)
    @card.stub!(:project=).and_return(@project)
    @card.stub!(:project).and_return(@project)
    @card.stub!(:number=).and_return(1)
  end
  
  def do_post
    post :create, :id => 1, :project_id => 1, :team_id => 1
  end
  
  def post_with_successful_save
    @card.should_receive(:save).and_return(@card)
    do_post
  end
  
  it "should find the team that was specified" do
    Team.should_receive(:find).and_return(@team)
    post_with_successful_save
  end
  it "should assign the created card to the specified team" do
    @card.should_receive(:team=).and_return(@team)
    post_with_successful_save
  end
end


describe CardsController, "handling POST /projects/1/cards" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    @card = mock_model(Card, :to_param => 1)
    
    Card.stub!(:new).and_return(@card)
    Project.stub!(:find).and_return(@project)
    @card.stub!(:project=).and_return(@project)
    @card.stub!(:project).and_return(@project)
    @card.stub!(:number=).and_return(1)
  end
  
  def do_post
    post :create, :id => 1, :project_id => 1
  end
  
  def post_with_successful_save
    @card.should_receive(:save).and_return(@card)
    do_post
  end
  
  it "should find the project that was passed in to assign to the card" do
    Project.should_receive(:find).with("1").and_return(@project)
    post_with_successful_save
  end
  
  it "should assign the created card to the project" do
    @card.should_receive(:project=).and_return(@project)
    post_with_successful_save
  end
  
  it "should assign the next number available to the card" do
    @card.should_receive(:number=).and_return(1)
    post_with_successful_save
  end
end

describe CardsController, "handling POST /cards.js" do
  before(:each) do
    @card = mock_model(Card, :to_param => 1)
    Card.stub!(:new).and_return(@card)
  end
  
  def do_post
    post :create, :id => 1, :format => :js
  end
  
  def post_with_successful_save
    @card.should_receive(:save).and_return(@card)
    do_post
  end
  
  it "should render the RJS on successful save"
end

describe CardsController, "handling POST /cards/generic_field_updater/1" do
  before(:each) do
    @card = mock_model(Card, :to_param => 1)
    #@project = mock_model(Project, :to_param => 1)
    Card.stub!(:find).and_return(@card)
    #Project.stub!(:find).and_return(@project)
    #@card.stub!(:update_attributes).and_return(2)
  end
  
  def do_post
    post :generic_field_updater, :id => 1, :model => 'Card', :value => 2, :field => 'project_id', :format => :js
  end
  
  it "should use generic_field_updater from ApplicationController to set field on card" do
    @card.should_receive( :update_attribute ).with( "project_id", "2" ).and_return( true )
    do_post
  end
  
  it "should render JSON on successful save"
end