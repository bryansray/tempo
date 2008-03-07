require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController, "#route_for" do
  it "should map { :controller => 'pages', :action => 'index' } to /pages" do
  	route_for(:controller => "pages", :action => "index").should == "/pages"
  end
  
  it "should map { :controller => 'pages', :action => 'show', :id => 1 } to /pages/1" do
  	route_for(:controller => "pages", :action => "show", :id => 1).should == "/pages/1"
  end
  
  it "should map { :controller => 'pages', :action => 'new' } to /pages/new" do
  	route_for(:controller => "pages", :action => "new").should == "/pages/new"
  end
  
  it "should map { :controller => 'pages', :action => 'edit', :id => 1 } to /pages/1/edit" do
  	route_for(:controller => "pages", :action => "edit", :id => 1).should == "/pages/1/edit"
  end
  
  it "should map { :controller => 'pages', :action => 'update', :id => 1 } to /pages/1" do
  	route_for(:controller => "pages", :action => "update", :id => 1).should == "/pages/1"
  end
  
  it "should map { :controller => 'pages', :action => 'destroy', :id => 1 } to /pages/1" do
  	route_for(:controller => "pages", :action => "destroy", :id => 1).should == "/pages/1"
  end
end


describe PagesController, "handling GET /pages" do
  before(:each) do
  	@page = mock_model(Page, :to_param => 1)
  	
  	Page.stub!(:find).and_return([@page])
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
  
  it "should find all published pages" do
  	Page.should_receive(:find).and_return([@page])

  	do_get
  end
   
  it "should assign the found pages to the view" do
  	do_get
  	
  	assigns[:recent_changes].should == [@page]
  end
end

describe PagesController, "handling GET /pages/1" do
  before(:each) do
    @page = mock_model(Page, :to_param => 1)
    @comment = mock_model(Comment, :to_param => 1)
    @content = mock_model(Content, :to_param => 1)
    @versions = [@content]

    Page.stub!(:find).and_return(@page)
    @page.stub!(:comments).and_return([@comment])
    @page.stub!(:content).and_return(@content)
    @versions.stub!(:find).and_return(@versions)
    @content.stub!(:versions).and_return(@versions)
    @page.stub!(:published?).and_return(true)
  end
  
  describe PagesController, "with ?version_id=1" do
    before(:each) do
      @old_content = mock_model(Content, :to_param => 2)
      
      @content.stub!(:revert_to!).and_return(@old_content)
    end
    
    def do_get
      get :show, :id => 1, :version_id => 1
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should assign the requested version to the view" do
      do_get
      @page.content.should eql(@content)
    end
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
  
  it "should find the page requested" do
    Page.should_receive(:find).and_return(@page)
    do_get
  end
  
  it "should find the last five versions that this page has" do
    @versions.should_receive(:find).with(:all, :limit => 5, :order => "updated_at DESC")
    do_get
  end
  
  it "should log a visit if the user is logged in and the page is published" do
    current_user = mock_model(User, :to_param => 1)
    visit = mock_model(Visit, :to_param => 1)
    visits = [visit]
    
    @page.should_receive(:published?).and_return(true)
    controller.should_receive(:current_user).twice.and_return(current_user)
    controller.should_receive(:logged_in?).and_return(true)
    current_user.should_receive(:visits).and_return(visits)
    visits.should_receive(:create).and_return(visit)
    
    do_get
  end
end

describe PagesController, "handling GET /pages/new" do
  before(:each) do
    @page = mock_model(Page, :to_param => 1)
	
    controller.stub!(:logged_in?).and_return(true)
    Page.stub!(:new).and_return(@page)
  end
  
  def do_get
    get :new
  end
  
  def do_unauthorized_get
    controller.should_receive(:authorized?).and_return(false)
    get :new
  end
  
  it "should redirect to the login page if you attempt to create a new page and are not logged in" do
    do_unauthorized_get
    response.should redirect_to(login_path)
  end
  
  it "should assign the flash variable if you attempt to create a new page while not logged in" do
    do_unauthorized_get
    flash[:notice].should_not be_empty
  end
  
  it "should be successful" do
  	do_get
    
  	response.should be_success
  end


  it "should render the new template" do
  	do_get
  	
  	response.should render_template("new")
  end
  
  it "should create a new page" do
  	Page.should_receive(:new).and_return(@page)
  	
  	do_get
  end
  
  it "should not save the new page" do
  	@page.should_not_receive(:save)
  	
  	do_get
  end
  
  it "should assign the new page for the view" do
  	do_get
  	
  	assigns[:page].should == @page
  end
end


# TODO - I'm pretty sure this can be refactored back in to the "edit" method
describe PagesController, "handling GET /pages/1/edit_tags" do
  before(:each) do
    @page = mock_model(Page, :to_param => 1)
    
    Page.stub!(:find).and_return(@page)
  end
  
  def do_get
    get :edit_tags, :id => 1
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the requested page" do
    Page.should_receive(:find).and_return(@page)
    do_get
  end
  
  it "should assign the found page to the view" do
    do_get
    assigns[:page].should == @page
  end
end

describe PagesController, "handling GET /pages/1/edit" do
  before(:each) do
  	@page = mock_model(Page, :to_param => 1)
  	
    controller.stub!(:logged_in?).and_return(true)
  	Page.stub!(:find).and_return(@page)
  end
  
  def do_get
  	get :edit, :id => 1
  end
    
  def do_unauthorized_get
    controller.should_receive(:authorized?).and_return(false)
    get :edit, :id => 1
  end
  
  it "should redirect if user is not authorized" do
    do_unauthorized_get
    response.should redirect_to(login_path)
  end
  
  it "should assign a flash notice if the user is not authorized" do
    do_unauthorized_get
    flash[:notice].should_not be_empty
  end
    
  it "should be successful" do
  	do_get
  	
  	response.should be_success
  end
  
  it "should render the edit template" do
  	do_get
  	
  	response.should render_template("edit")
  end
  
  it "should find the page requested" do
  	Page.should_receive(:find).and_return(@page)
  	
  	do_get
  end
  
  it "should assign the requested page to the view" do
    do_get
    
    assigns[:page].should == @page
  end
end

describe PagesController, "handling POST /pages" do
  before(:each) do
    @page = mock_model(Page, :to_param => 1)
    @content = mock_model(Content, :to_param => 1)
    @tag_list = mock_model(TagList)

    Page.stub!(:new).and_return(@page)
    @page.stub!(:build_content).and_return(@content)
    @content.stub!(:tag_list).and_return(@tag_list)
    @tag_list.stub!(:add).and_return(@tag_list)
  end
  
  def do_post
  	post :create, :page => {}, :content => {}
  end
  
  def post_with_successful_save
  	@page.should_receive(:save).and_return(true)
  	do_post
  end
  
  def post_with_failed_save
  	@page.should_receive(:save).and_return(false)
  	do_post
  end
  
  it "should create a new page" do
  	Page.should_receive(:new).with({}).and_return(@page)
  	@page.should_receive(:build_content).with({}).and_return(@content)
  	post_with_successful_save
  end
  
  it "should redirect to the new page on successful save" do
  	post_with_successful_save
  	
  	response.should redirect_to(page_path(@page))
  end
  
  it "should re-render the 'new' template on failed save" do
  	post_with_failed_save

  	response.should render_template("new")
  end
end

describe PagesController, "handling PUT /pages/1" do
  before(:each) do
    @user = mock_model(User, :to_param => 1)
    @current_user = mock_model(User, :to_param => 2)
    @page = mock_model(Page, :to_param => 1)
    @content = mock_model(Content, :user => @user, :to_param => 1)
	@tag_list = mock_model(TagList)

    Page.stub!(:find).and_return(@page)
    @page.stub!(:content).and_return(@content)
    @page.stub!(:tag_list).and_return(@tag_list)
	@tag_list.stub!(:add).and_return(@tag_list)
    @content.stub!(:user=)
    controller.stub!(:current_user).and_return(@current_user)
  end
  
  def do_put
  	put :update, :id => 1
  end
  
  def put_with_successful_update
  	@page.should_receive(:update_attributes).and_return(true)
  	@content.should_receive(:update_attributes).and_return(true)
  	do_put
  end
  
  def put_with_failed_update
  	@page.should_receive(:update_attributes).and_return(false)

  	do_put
  end
  
  it "should assign the current_user to page.content.user" do
    @content.should_receive(:user=).with(@current_user)
    
    put_with_successful_update
  end
  
  it "should find the page requested" do
  	Page.should_receive(:find).and_return(@page)
  	put_with_successful_update
  end

  it "should assign the found page for the view" do
  	put_with_successful_update
  	assigns[:page].should == @page
  end
  it "should redirect to the page on successful update" do
  	put_with_successful_update
  	response.should redirect_to(page_path(@page))
  end
  it "should re-render 'edit' on failed update" do
  	put_with_failed_update
  	response.should render_template("edit")
  end
  
  it "should assign the tags to the pages content" do
	@tag_list.should_receive(:add).and_return(@tag_list)
	put_with_successful_update
  end
end

describe PagesController, "handling DELETE /pages/1" do
  before(:each) do
  	@page = mock_model(Page, :to_param => 1, :destroy => true)
  	
  	Page.stub!(:find).and_return(@page)
  end
  
  def do_delete
  	delete :destroy, :id => 1
  end
  
  it "should find the page requested" do
  	Page.should_receive(:find).with("1").and_return(@page)
  	do_delete
  end
  
  it "should call destroy on the page requested" do
  	@page.should_receive(:destroy)
  	
  	do_delete
  end
  
  it "should redirect to the list of pages" do
  	do_delete
  	
  	response.should redirect_to(pages_path)
  end
end