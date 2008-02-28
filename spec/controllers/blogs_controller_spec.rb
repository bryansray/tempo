require File.dirname(__FILE__) + '/../spec_helper'

describe BlogsController, "#route_for" do
  it "should map { :controller => 'blogs', :action => 'index' } to /blogs" do
    route_for(:controller => "blogs", :action => "index").should == "/blogs"
  end
  
  it "should map { :controller => 'blogs', :action => 'new' } to /blogs/new" do
    route_for(:controller => "blogs", :action => "new").should == "/blogs/new"
  end
  
  it "should map { :controller => 'blogs', :action => 'show', :id => 1 } to /blogs/1" do
    route_for(:controller => "blogs", :action => "show", :id => 1).should == "/blogs/1"
  end
  
  it "should map { :controller => 'blogs', :action => 'edit', :id => 1 } to /blogs/1/edit" do
    route_for(:controller => "blogs", :action => "edit", :id => 1).should == "/blogs/1/edit"
  end
 
  it "should map { :controller => 'blogs', :action => 'update', :id => 1} to /blogs/1" do
    route_for(:controller => "blogs", :action => "update", :id => 1).should == "/blogs/1"
  end
  
  it "should map { :controller => 'blogs', :action => 'destroy', :id => 1 } to /blogs/1" do
    route_for(:controller => "blogs", :action => "destroy", :id => 1).should == "/blogs/1"
  end  
end

describe BlogsController, "handling GET /blogs" do
	before(:each) do
	  @post = mock_model(Post, :to_param => 1, :published => true)
	  
	  Post.stub!(:find_published).and_return([@post])
	end
	
	def do_get
	  get :index
	end
	
	it "should be successful" do
	  do_get
	  
	  response.should be_success
	end
	
	it "should find the published posts for the requested blog" do
		Post.should_receive(:find_published).and_return([@post])
		do_get
	end
	
	it "should render the index template" do
	  do_get
	  
	  response.should render_template("index")
	end
	
	it "should assign the published posts to the view" do
	  do_get
	  
	  assigns[:posts].should == [@post]
	end
end

describe BlogsController, "handling GET /blogs/1" do
  before(:each) do
  	@blog = mock_model(Blog, :to_param => 1)
    @post = mock_model(Post, :to_param => 1)
    
  	Blog.stub!(:find).and_return(@blog)
    @blog.stub!(:posts).and_return([@post])
  end
  
  def do_get
  	get :show, :id => 1
  end
  
  it "should be successful" do
  	do_get
  	
  	response.should be_success
  end
  
  it "should find the blog requested" do
  	Blog.should_receive(:find).with("1").and_return(@blog)

  	do_get
  end
  
  it "should render the show template" do
  	do_get
  	
  	response.should render_template("show")
  end
  
  it "should assign the blog to the view" do
  	do_get
  	
  	assigns[:blog].should == @blog
  end
end

describe BlogsController, "handling GET /blogs/new" do
  before(:each) do
    @blog = mock_model(Blog, :to_param => 1)
    Blog.stub!(:new).and_return(@blog)
  end
  
  def do_get
    get :new, :user_id => 1
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
end

describe BlogsController, "handling GET /blogs/1/edit" do

  before do
    @blog = mock_model(Blog)
    Blog.stub!(:find).and_return(@blog)
  end
  
  def do_get
    get :edit, :user_id => 1, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the blog requested" do
    Blog.should_receive(:find).and_return(@blog)
    do_get
  end
  
  it "should assign the found Blog for the view" do
    do_get
    assigns[:blog].should equal(@blog)
  end
end

describe BlogsController, "handling POST /blogs" do
  before(:each) do
  	@blog = mock_model(Blog, :to_param => 1)
  	@user = mock_model(User, :to_param => 1)
  	@blogs = [@blog]
  	
  	@blogs.stub!(:build).and_return(@blog)
  	@user.stub!(:blogs).and_return(@blogs)
  	
  	controller.stub!(:current_user).and_return(@user)
  end
  
  def do_post
  	post :create, :blog => {}, :current_user => @user
  end
  
  def post_with_successful_save
  	@user.should_receive(:save).and_return(true)
  	
  	do_post
  end
  
  def post_with_failed_save  
  	@user.should_receive(:save).and_return(false)
  	
  	do_post
  end
  
  it "should create the blog for the current_user" do
  	@blogs.should_receive(:build).and_return(@blog)
  	
  	post_with_successful_save
  end
  
  it "should redirect to the new blog on successful save" do
  	post_with_successful_save
  	
  	response.should redirect_to(blog_path(@blog))
  end
  
  it "should re-render 'new' on failed save" do
  	post_with_failed_save
  	
  	response.should render_template("new")
  end
end

describe BlogsController, "handling PUT /blogs/1" do
  before do
    @blog = mock_model(Blog, :to_param => "1")

    Blog.stub!(:find).and_return(@blog)
  end
  
  def put_with_successful_update
    @blog.should_receive(:update_attributes).and_return(true)

    put :update, :id => 1, :blog => {}
  end
  
  def put_with_failed_update
    @blog.should_receive(:update_attributes).and_return(false)
    
    put :update, :id => 1, :blog => {}
  end
  
  it "should find the blog requested" do
    Blog.should_receive(:find).with("1").and_return(@blog)
    put_with_successful_update
  end

  it "should update the found blog" do
    put_with_successful_update
    assigns(:blog).should equal(@blog)
  end

  it "should assign the found blog for the view" do
    put_with_successful_update
    assigns(:blog).should equal(@blog)
  end

  it "should redirect to the blog on successful update" do
    put_with_successful_update
    response.should redirect_to(blog_url(1))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe BlogsController, "handling DELETE /blogs/1" do

  before do
    @blog = mock_model(Blog, :destroy => true)
    Blog.stub!(:find).and_return(@blog)
    
    params[:user_id] = "1"
  end
  
  def do_delete
    delete :destroy, :user_id => 1, :id => "1"
  end

  it "should find the blog requested" do
    Blog.should_receive(:find).with("1").and_return(@blog)
    do_delete
  end
  
  it "should call destroy on the found blog" do
    @blog.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the blogs list" do
    do_delete

    response.should redirect_to(blogs_url)
  end
end
