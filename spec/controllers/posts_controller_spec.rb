require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController, "#route_for" do
  
  it "should map { :controller => 'posts', :action => 'index' } to /posts" do
    route_for( :controller => "posts", :action => "index").should == "/posts"
  end
  
  it "should map { :controller => 'posts', :action => 'edit' } to /posts/1/edit" do
    route_for( :controller => "posts", :action => "edit", :id => 1).should == "/posts/1/edit"
  end
  
  it "should map { :controller => 'posts', :action => 'new' } to /posts/new" do
    route_for( :controller => "posts", :action => "new" ).should == "/posts/new"
  end
  
  it "should map { :controller => 'posts', :action => 'show', :id => 1 } to /posts/1" do
    route_for( :controller => "posts", :action => "show", :id => 1).should == "/posts/1"
  end
  
  it "should map { :controller => 'posts', :action => 'destroy', :id => 1 } to /posts/1" do
    route_for(:controller => "posts", :action => "destroy", :id => 1).should == "/posts/1"
  end
end

describe PostsController, "handling GET /posts" do
  before(:each) do
    @post = mock_model(Post)
    
    Post.stub!(:find).and_return([@post])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    
    response.should be_success
  end
  
  it "should render an index template" do
    do_get
    
    response.should render_template('index')
  end
  
  it "should find all posts" do
    Post.should_receive(:find).with(:all, :order => "created_at DESC").and_return([@post])

    do_get
  end
  
  it "should assign the post to the associated view" do
    do_get
    
    assigns[:posts].should == [@post]
  end
end

describe PostsController, "handling GET /posts/1 with a user that is not logged in" do
  before(:each) do
    @post = mock_model(Post, :to_param => 1)
    @comment = mock_model(Comment, :to_param => 1)
    @version = mock_model(Content, :to_param => 1)
    @versions = [@version]
    
    Post.stub!(:find).and_return(@post)
    @post.stub!(:comments).and_return([@comment])
    @post.stub!(:versions).and_return(@versions)
    @versions.stub!(:find).and_return(@versions)
    
    controller.stub!(:logged_in?).and_return(false)
  end
  
  describe PostsController, "with ?version_id=1" do
    before(:each) do
      
    end
    
    it "should be successful"
    it "should find the requested version of the post"
    it "should assign the correct version to the requesting view"
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
  
  it "should find the post requested" do
    Post.should_receive(:find).and_return(@post)
    do_get
  end
  
  it "should not log the page view if the user is not logged in" do
    controller.should_receive(:logged_in?).and_return(false)
    do_get
  end
end

describe PostsController, "handling GET /posts/1 with a user that is logged in" do
  before(:each) do
    @user = mock_model(User, :to_param => 1)
    @post = mock_model(Post, :to_param => 1)
    @comment = mock_model(Comment, :to_param => 1)
    @visit = mock_model(Visit, :to_param => 1)
    @content = mock_model(Content, :to_param => 1)
    @versions = [@content]
    
    @visits = [@visit]
    
    Post.stub!(:find).and_return(@post)
    @post.stub!(:comments).and_return([@comment])
    @post.stub!(:versions).and_return(@versions)
    @versions.stub!(:find).and_return(@versions)
    @post.stub!(:published?).and_return(true)
    @post.stub!(:content).and_return(@content)
    @user.stub!(:visits).and_return(@visits)
    @visits.stub!(:create).and_return(@visit)
    
    controller.stub!(:logged_in).and_return(true)
    controller.stub!(:current_user).and_return(@user)
  end
  
  def do_get
    get :show, :id => 1
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should log the page view for the currently logged in user" do    
    @user.should_receive(:visits).and_return(@visits)
    @visits.should_receive(:create).with(:user => @user, :content => @content).and_return(@visit)
    do_get
  end
end

describe PostsController, "handling GET /posts/new" do
  before(:each) do
    @post = mock_model(Post, :to_param => 1)
    @user = mock_model(User, :to_param => 1)
    @blog = mock_model(Blog, :to_param => 1)

    @user.stub!(:blogs).and_return([@blog])
    controller.stub!(:authorized?).and_return(true)
    controller.stub!(:current_user).exactly(3).times.and_return(@user)

    Post.stub!(:new).and_return(@post)
  end
  
  def do_get
  	get :new, :user_id => 1, :blog_id => 1
  end
  
  def do_unauthorized_get
    #controller.stub!(:authorized?).and_return(false)
    controller.should_receive(:current_user).exactly(3).times.and_return(@user)

    get :new, :user_id => 2, :blog_id => 1
  end

#  it "should redirect to the users blog if not authorized to create post" do
#    do_unauthorized_get
#    
#    response.should be_redirect
#  end

#  it "should assign a flash notic if not authorized to create a new post" do
#    do_unauthorized_get
#    
#    flash[:notice].should_not be_empty
#  end
  
  it "should be successful" do
  	do_get
  	
  	response.should be_success
  end
  
#  it "should render 'new' template" do
#  	do_get
#  	
#  	response.should render_template("new")
#  end
#  
#  it "should create a new post" do
#  	Post.should_receive(:new).and_return(@post)
#  	do_get
#  end
#  
#  it "should not save the new post" do
#  	@post.should_not_receive(:save)
#  	do_get
#  end
#  
#  it "should assign the new post to the view" do
#  	do_get
#  	
#  	assigns[:post].should == @post
#  end
end

describe PostsController, "handling GET /posts/1/edit" do
  before(:each) do
  	@post = mock_model(Post, :to_param => 1)
    @content = mock_model(Content, :to_param => 1)
  	
    controller.stub!(:authorized?).and_return(true)
  	Post.stub!(:find).and_return(@post)
    @post.stub!(:content).and_return(@content)
  end
  
  def do_get
  	get :edit, :user_id => 1, :blog_id => 1, :id => 1
  end
  
  def do_unauthorized_get
    controller.should_receive(:authorized?).and_return(false)
    
    get :edit, :user_id => 1, :blog_id => 1, :id => 1
  end
  
  it "should be successful" do
    do_get
  	response.should be_success
  end
  
  it "should redirect to the post if user is not authorized" do
    do_unauthorized_get
    
    response.should redirect_to(login_path)
  end
  
  it "should assign a flash notice if current_ser is not authorized to edit the post" do
    do_unauthorized_get
    
    flash[:notice].should_not be_empty
  end
  
  it "should render 'edit' template" do
  	do_get
  	
  	response.should render_template("edit")
  end
  
  it "should find the post that was requested" do
  	Post.should_receive(:find).with("1").and_return(@post)
  	do_get
  end
  
  it "should assign the post to the view" do
  	do_get
  	assigns[:post].should == @post
  end
end

describe PostsController, "handling POST /posts" do
  before(:each)	do
    @blog = mock_model(Blog, :to_param => 1)
    @post = mock_model(Post, :to_param => 1)
    @content = mock_model(Content, :to_param => 1)
    @current_user = mock_model(User, :to_param => 1)

    controller.stub!(:current_user).and_return(@current_user)
    @current_user.stub!(:blogs).and_return([@blog])
    Post.stub!(:new).and_return(@post)
    @post.stub!(:build_content).and_return(@content)
    @content.stub!(:user=)
    @content.stub!(:published_at=)
  end
  
  def do_post
  	post :create, :post => {}, :user_id => 1, :blog_id => 1
  end
  
  def post_with_successful_save
  	@post.should_receive(:save).and_return(true)
  	do_post
  end
  
  def post_with_failed_save
  	@post.should_receive(:save).and_return(false)
  	do_post
  end
  
  it "should create a new post" do
  	Post.should_receive(:new).and_return(@post)
  	@post.should_receive(:build_content).and_return(@content)
  	
  	post_with_successful_save
  end
  
  it "should set the published_at date" do
    @content.should_receive(:published_at=)
    post_with_successful_save
  end
  
  it "should redirect to post on successful save" do
  	post_with_successful_save
  	
  	response.should redirect_to(post_path(@post))
  end
  
  it "should re-render 'new' on failed save" do
  	post_with_failed_save
  	
  	response.should render_template("new")
  end
end

describe PostsController, "handling PUT /posts/1/update_tags" do
  before(:each) do
    @post = mock_model(Post, :to_param => 1)
    
    Post.stub!(:find).and_return(@post)
  end
end

describe PostsController, "handling PUT /posts/1" do
  before(:each)	do
    @current_user = mock_model(User, :to_param => 1)
    @post = mock_model(Post, :to_param => 1)
    @content = mock_model(Content, :to_param => 1)
    @tag_list = mock_model(TagList)
	
    controller.stub!(:current_user).and_return(@current_user)
    @post.stub!(:content).and_return(@content)
    @post.stub!(:tag_list).and_return(@tag_list)
    @tag_list.stub!(:add).and_return(@tag_list)
    @content.stub!(:user=)
    Post.stub!(:find).and_return(@post)
  end
  
  def do_put
    put :update, :post => {}, :content => {}, :user_id => 1, :blog_id => 1, :id => 1
  end
  
  def put_with_successful_save
    @post.should_receive(:update_attributes).with({}).and_return(true)
    @content.should_receive(:update_attributes).with({}).and_return(true)

    do_put
  end
  
  def put_with_failed_save
    @post.should_receive(:update_attributes).with({}).and_return(false)

    do_put
  end
  
  def put_with_failed_content_save
    @post.should_receive(:update_attributes).with({}).and_return(true)
    @content.should_receive(:update_attributes).with({}).and_return(false)
    do_put
 end
  
  it "should save the logged in user as the last person who edited the content" do
    @content.should_receive(:user=).with(@current_user)
    
    put_with_successful_save
  end
  
  it "should find the requested post" do
    Post.should_receive(:find).with("1").and_return(@post)
    put_with_successful_save
  end
  
  it "should update the post and content that was found" do
    put_with_successful_save

    assigns[:post].should == @post
  end
  
  it "should redirect to the post on successful update" do
    put_with_successful_save

    response.should redirect_to(post_path(@post))
  end
  
  it "should render the 'edit' template on failed save" do
    put_with_failed_save

    response.should render_template("edit")
  end
  
  it "should render the 'edit' template on failed content save" do
    put_with_failed_content_save
    response.should render_template("edit")
  end
end

describe PostsController, "handling DELETE /posts/1" do
  before(:each) do
    @post = mock_model(Post, :to_param => 1, :destroy => true)

    Post.stub!(:find).and_return(@post)
  end
  
  def do_delete
    delete :destroy, :user_id => 1, :blog_id => 1, :id => 1
  end
  
  it "should find the post requested" do
    Post.should_receive(:find).with("1").and_return(@post)
    do_delete
  end
  it "should call destroy on the found post" do
    @post.should_receive(:destroy).and_return(true)

    do_delete
  end
  
  it "should redirect to the list of posts for the blog" do
    do_delete
    response.should redirect_to(posts_path)
  end
end