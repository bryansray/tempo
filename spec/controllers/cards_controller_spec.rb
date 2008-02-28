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
end

describe CardsController, "handling GET /projects/1/cards" do
  before(:each) do
    @project = mock_model(Project, :to_param => 1)
    @card = mock_model(Card, :to_param => 1)    
    @cards = [@card]

    Project.stub!(:find).and_return(@project)
  end
  
  def do_get
    get :index, :project_id => 1
  end
  
  it "should find the project to list the cards for" do
    Project.should_receive(:find).and_return(@project)
    do_get
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should assign the project to the specified view" do
    do_get
    assigns[:project].should eql(@project)
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

describe CardsController, "handling POST /teams/1/cards" do
  before(:each) do
    @team = mock_model(Team, :to_param => 1)
    @card = mock_model(Card, :to_param => 1)
    
    Card.stub!(:new).and_return(@card)
    Team.stub!(:find).and_return(@team)
    @card.stub!(:team=).and_return(@team)
  end
  
  def do_post
    post :create, :id => 1, :team_id => 1
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
end

describe CardsController, "handling POST /cards" do
  before(:each) do
    @card = mock_model(Card, :to_param => 1)
    Card.stub!(:new).and_return(@card)
  end
  
  def do_post
    post :create, :id => 1
  end
  
  def post_with_successful_save
    @card.should_receive(:save).and_return(true)
    do_post
  end
  
  def post_with_unsuccessful_save
    @card.should_receive(:save).and_return(false)
    do_post
  end
  
  it "should create a new card to be saved" do
    Card.should_receive(:new).and_return(@card)
    post_with_successful_save
  end
  
  it "should redirect to the new card on successful save" do
    post_with_successful_save
    response.should redirect_to(card_path(@card))
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