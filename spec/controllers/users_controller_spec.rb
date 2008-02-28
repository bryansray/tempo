require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController, "handling GET /users" do
  it "should use UsersController" do
    controller.should be_an_instance_of(UsersController)
  end
  
  before(:each) do
    @user = mock_model(User)
    User.stub!(:find).and_return([@user])
  end
  
  def do_get
    get :index
  end
  
  it "should should be successful" do
    do_get    
    response.should be_success
  end
  
  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all users" do
    User.should_receive(:find).with(:all).and_return([@user])
    do_get
  end
  
  it "should assign the found users for the view" do
    do_get
    
    assigns[:users].should == [@user]
  end
end

describe UsersController, "handling GET /users/1 with owner logged in" do
  before(:each) do
    @user = mock_model(User, :to_param => 1)
    @content = mock_model(Content, :to_param => 1)
    @blog = mock_model(Blog, :to_param => 1)
    @post = mock_model(Post, :to_param => 1)
    @page = mock_model(Page, :to_param => 1)
    @visit = mock_model(Visit, :to_param => 1)
    
    @blogs = [@blog]
    @posts = [@post]
    @pages = [@page]
    @contents = [@content]
    @visits = [@visit]
    
    User.stub!(:find).and_return(@user)
    @user.stub!(:contents).and_return(@contents)
    @contents.stub!(:find).and_return(@contents)
    
    controller.stub!(:current_user).and_return(@user)
    
    @user.stub!(:blogs).and_return(@blogs)
    @blog.stub!(:posts).and_return(@posts)
    @user.stub!(:pages).and_return(@pages)
    
    Visit.stub!(:find).and_return(@visits)
  end
  
  def do_get
    get :show, :id => 1
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should assign an array of posts and pages (draft and published) to the view" do
    @blog.should_receive(:posts).and_return(@posts)
    @user.should_receive(:pages).and_return(@pages)
    do_get
  end
  
  it "should render the show template" do
    do_get
    response.should render_template("show")
  end
  
  it "should find the user that was requested" do
    User.should_receive(:find).and_return(@user)
    do_get
  end
  
  it "should return the last 15 pieces of content sorted in descending order" do
    @contents.should_receive(:find).with(:all, :conditions => ['published = ?', true], :limit => 15, :order => "updated_at DESC").and_return(@contents)
    do_get
  end
  
  it "should make a call to retrieve all posts and pages" do
    @user.should_receive(:pages).and_return(@pages)
    @blog.should_receive(:posts).and_return(@posts)
    do_get
  end
  
  it "should assign the users contents to the view" do
    @contents.should_receive(:find).with(:all, :conditions => ['published = ?', true], :limit => 15, :order => "updated_at DESC").and_return(@contents)
    do_get
    assigns[:contents].should == @contents
  end
  
  it "should assign posts and pages to the associated view" do
    do_get
    assigns[:posts].should == @posts
    assigns[:pages].should == @pages
  end
  
  it "should assign which content the requested user has visited to the view" do
    do_get
    assigns[:visits].should == @visits
  end
end

describe UsersController, "handling GET /users/1 with owner not logged in" do
  before(:each) do
    @user = mock_model(User, :to_param => 1)

    @visit = mock_model(Visit, :to_param => 1)
    @content = mock_model(Content, :to_param => 1)
    @blog = mock_model(Blog, :to_param => 1)
    @post = mock_model(Post, :to_param => 1)
    @page = mock_model(Page, :to_param => 1)
    
    @contents = [@content]
    @visits = [@visit]
    @blogs = [@blog]
    @posts = [@post]
    @pages = [@page]
    
    User.stub!(:find).and_return(@user)
    @user.stub!(:contents).and_return(@contents)
    @contents.stub!(:find).and_return(@contents)
    
    Visit.stub!(:visits).and_return(@visits)
    @user.stub!(:blogs).and_return(@blogs)
    @blog.stub!(:published_posts).and_return(@posts)
    @user.stub!(:published_pages).and_return(@pages)
  end
  
  def do_get
    get :show, :id => 1
  end
  
  it "should be successful" do
    do_get
    
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    
    response.should render_template('show')
  end
  
  it "should find the user requested" do
    User.should_receive(:find).with("1").and_return(@user)
    
    do_get
  end
  
  it "should assign the found user to the view" do
    do_get
    
    assigns[:user].should == @user
  end
  
  it "should make a call to get the posts and pages that are published only" do
    @blog.should_receive(:published_posts).and_return(@posts)
    @user.should_receive(:published_pages).and_return(@pages)
    do_get
  end
  
  it "should assign pages and posts for the requested user to the associated view" do
    do_get
    assigns[:posts].should == @posts
    assigns[:pages].should == @pages
  end
  
  it "should assign visits for the requested user to the associated view" do
    Visit.should_receive(:find).and_return(@visits)
    do_get
    assigns[:visits].should == @visits
  end
end

describe UsersController, "handling GET /users/new" do
  before(:each) do
    @user = mock_model(User)
    User.stub!(:new).and_return(@user)
  end
  
  def do_get
    get :new
  end
  
  it "should be successful" do
    do_get
    
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    
    response.should render_template('new')
  end
  
  it "should create a new user" do
    User.should_receive(:new).and_return(@user)
    
    do_get
  end
  
  it "should assign the new user for the view" do
    do_get
    
    assigns[:user].should equal(@user)
  end
end

describe UsersController, "handling GET /users/1/edit" do
  before(:each) do
    @user = mock_model(User)
    User.stub!(:find).and_return(@user)
  end
  
  def do_get
    get :edit, :id => 1
  end
  
  it "should be successful" do
    do_get
    
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    
    response.should render_template('edit')
  end
  
  it "should find the user requested" do
    User.should_receive(:find).and_return(@user)
    
    do_get
  end
  
  it "should assign the found user to the view" do
    do_get
    
    assigns[:user].should equal(@user)
  end
end

describe UsersController, "handling POST /users" do
  before(:each) do
    @user = mock_model(User, :to_param => 1)
    @blog = mock_model(Blog, :to_param => 1)
    
    @blogs = [@blog]
    
    User.stub!(:new).and_return(@user)
    @user.stub!(:blogs).and_return(@blogs)
    Blog.stub!(:new).and_return(@blog)
    @blogs.stub!(:build).and_return(@blog)
  end

  def post_with_successful_save
    @user.should_receive(:save).and_return(true)

    post :create, :user => {}
  end
  
  def post_with_failed_save
    @user.should_receive(:save).and_return(false)
    
    post :create, :user => {}
  end
  
  it "should create a new user and assign a default blog" do
    User.should_receive(:new).with({}).and_return(@user)
	@user.should_receive(:blogs).and_return(@blogs)
	@blogs.should_receive(:build).and_return(@blog)
    
    post_with_successful_save
  end
  
  it "should redirect to the new user on successful save" do
  	post_with_successful_save
  	
  	response.should redirect_to(user_url(1))
  end
end

describe UsersController, "handling PUT /users/1" do
  before(:each) do
  	@user = mock_model(User, :to_param => 1)
  	
  	User.stub!(:find).and_return(@user)
  end
  
  def do_put
  	put :update, :user => {}, :id => 1
  end
  
  def put_with_successful_update
  	@user.should_receive(:update_attributes).and_return(true)
  	do_put
  end
  
  def put_with_failed_update
  	@user.should_receive(:update_attributes).and_return(false)
  	do_put
  end
  
  it "should find the user requested" do
  	User.should_receive(:find).and_return(@user)
  	put_with_successful_update
  end
  
  it "should update the located user" do
  	put_with_successful_update
  	assigns[:user].should == @user
  end
  it "should redirect to the user on successful update" do
    put_with_successful_update
    response.should redirect_to(user_path(1))
  end
  
  it "should re-render the 'edit' template on failed update" do
    put_with_failed_update
    response.should render_template("edit")
  end
end

describe UsersController, "handling DELETE /users/1" do
  before(:each) do
  	@user = mock_model(User, :to_param => 1, :destroy => true)
  	
  	User.stub!(:find).and_return(@user)
  end
	
  def do_delete
    delete :destroy, :id => 1
  end
  
  it "should find the requested user" do
  	User.should_receive(:find).and_return(@user)
  	do_delete
  end
  
  it "should call destroy on the located user" do
  	@user.should_receive(:destroy).and_return(@user)
  	do_delete
  end
  
  it "should redirect to the list of users after delete" do
  	do_delete
  	
  	response.should redirect_to(users_path)
  end
end