require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController, "#route_for" do

#  it "should map { :controller => 'comments', :action => 'index' } to /pages/1/comments" do
#    route_for(:controller => "comments", :action => "index", :page_id => 1).should == "/pages/1/comments"
#  end
  
  it "should map { :controller => 'comments', :action => 'new' } to /comments/new" do
    route_for(:controller => "comments", :action => "new", :page_id => 1).should == "/pages/1/comments/new"
  end
  
#  it "should map { :controller => 'comments', :action => 'show', :id => 1 } to /pages/1/comments/1" do
#    route_for(:controller => "comments", :action => "show", :page_id => 1, :id => 1).should == "/pages/1/comments/1"
#  end
  
  it "should map { :controller => 'comments', :action => 'edit', :page_id => 1, :id => 1 } to /pages/1/comments/1/edit" do
    route_for(:controller => "comments", :action => "edit", :page_id => 1, :id => 1).should == "/pages/1/comments/1/edit"
  end
  
  it "should map { :controller => 'comments', :action => 'update', :page_id => 1, :id => 1} to /pages/1/comments/1" do
    route_for(:controller => "comments", :action => "update", :page_id => 1, :id => 1).should == "/pages/1/comments/1"
  end
  
  it "should map { :controller => 'comments', :action => 'destroy', :page_id => 1, :id => 1} to /pages/1/comments/1" do
    route_for(:controller => "comments", :action => "destroy", :page_id => 1, :id => 1).should == "/pages/1/comments/1"
  end
  
end

#describe CommentsController, "handling GET /posts/1/comments" do
#  before(:each) do
#    @post = mock_model(Post, :to_param => 1)
#    @comment = mock_model(Comment, :to_param => 1)
#    
#    Comment.stub!(:find).and_return([@comment])
#  end
#  
#  def do_get
#    get :index, :post_id => 1
#  end
#  
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#  
#  it "should render the index template" do
#    do_get
#    respond.should render_template('index')
#  end
#  
#  it "should find all the comments for the post" do
#    
#  end
#end

#describe CommentsController, "handling GET /pages/1/comments" do
#
#  before do
#    @comment = mock_model(Comment)
#    Comment.stub!(:find).and_return([@comment])
#  end
#  
#  def do_get
#    get :index, :page_id => 1
#  end
#  
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#
#  it "should render index template" do
#    do_get
#    response.should render_template('index')
#  end
#  
#  it "should find all comments" do
#    Comment.should_receive(:find).with(:all).and_return([@comment])
#    do_get
#  end
#  
#  it "should assign the found comments for the view" do
#    do_get
#    assigns[:comments].should == [@comment]
#  end
#end

#describe CommentsController, "handling GET /pages/1/comments.xml" do
#
#  before do
#    @comment = mock_model(Comment, :to_xml => "XML")
#    Comment.stub!(:find).and_return(@comment)
#  end
#  
#  def do_get
#    @request.env["HTTP_ACCEPT"] = "application/xml"
#    get :index, :page_id => 1
#  end
#  
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#
#  it "should find all comments" do
#    Comment.should_receive(:find).with(:all).and_return([@comment])
#    do_get
#  end
#  
#  it "should render the found comments as xml" do
#    @comment.should_receive(:to_xml).and_return("XML")
#    do_get
#    response.body.should == "XML"
#  end
#end

#describe CommentsController, "handling GET /pages/1/comments/1" do
#
#  before do
#    @comment = mock_model(Comment)
#    Comment.stub!(:find).and_return(@comment)
#  end
#  
#  def do_get
#    get :show, :page_id => 1, :id => "1"
#  end
#
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#  
#  it "should render show template" do
#    do_get
#    response.should render_template('show')
#  end
#  
#  it "should find the comment requested" do
#    Comment.should_receive(:find).with("1").and_return(@comment)
#    do_get
#  end
#  
#  it "should assign the found comment for the view" do
#    do_get
#    assigns[:comment].should equal(@comment)
#  end
#end
#
#describe CommentsController, "handling GET /pages/1/comments/1.xml" do
#
#  before do
#    @comment = mock_model(Comment, :to_xml => "XML")
#    Comment.stub!(:find).and_return(@comment)
#  end
#  
#  def do_get
#    @request.env["HTTP_ACCEPT"] = "application/xml"
#    get :show, :page_id => 1, :id => "1"
#  end
#
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#  
#  it "should find the comment requested" do
#    Comment.should_receive(:find).with("1").and_return(@comment)
#    do_get
#  end
#  
#  it "should render the found comment as xml" do
#    @comment.should_receive(:to_xml).and_return("XML")
#    do_get
#    response.body.should == "XML"
#  end
#end

describe CommentsController, "handling GET /pages/1/comments/new" do

  before do
    @comment = mock_model(Comment)
    Comment.stub!(:new).and_return(@comment)
  end
  
  def do_get
    get :new, :page_id => 1
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new comment" do
    Comment.should_receive(:new).and_return(@comment)
    do_get
  end
  
  it "should not save the new comment" do
    @comment.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new comment for the view" do
    do_get
    assigns[:comment].should equal(@comment)
  end
end

describe CommentsController, "handling GET /pages/1/comments/1/edit" do

  before do
    @comment = mock_model(Comment)
    Comment.stub!(:find).and_return(@comment)
  end
  
  def do_get
    get :edit, :page_id => 1, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the comment requested" do
    Comment.should_receive(:find).and_return(@comment)
    do_get
  end
  
  it "should assign the found Comment for the view" do
    do_get
    assigns[:comment].should equal(@comment)
  end
end

describe CommentsController, "handling POST /pages/1/comments" do
  before(:each) do
    @current_user = mock_model(User, :to_param => 1)

    @page = mock_model(Page, :to_param => 1)
    @content = mock_model(Content, :to_param => 1)
    @comment = mock_model(Comment, :to_param => "1", :user => @current_user, :content => @content)
    @comments = [@comment, @comment]

    controller.stub!(:current_user).and_return(@current_user)

    Comment.stub!(:new).and_return(@comment)
    @comment.stub!(:build_content).and_return(@content)

    @comment.stub!(:user=)
    @content.stub!(:user=)
    @content.stub!(:published=).and_return(true)

    Page.stub!(:find).and_return(@page)
    @page.stub!(:comments).and_return(@comments)
    
    @comment.stub!(:commentable).and_return(@page)
  end
  
  def post_with_successful_save
    @content.should_receive(:user=).with(@current_user)
    @content.should_receive(:published=).and_return(true)
    @comment.should_receive(:save).and_return(true)
    post :create, :comment => {}, :content => {}, :page_id => 1
  end
  
  def post_with_failed_save
    @comment.should_receive(:save).and_return(false)
    post :create, :comment => {}, :content => {}, :page_id => 1
  end
  
  it "should be redirected" do
    post_with_successful_save

    response.should be_redirect
  end
  
  it "should populate the flash[:notice] after successful save" do
    post_with_successful_save
    
    flash[:notice].should_not be_empty
  end
  
  it "should redirect back to the page after successful save" do
    post_with_successful_save
    
    response.should redirect_to(page_path(1))
  end
  
  it "should redirect back to the page after failed save" do
    post_with_failed_save
    
    response.should redirect_to(page_path(1))
  end
end

describe CommentsController, "handling POST /posts/1/comments" do
  before(:each) do
  	@current_user = mock_model(User, :to_param => 1)

  	@post = mock_model(Post, :to_param => 1)
  	@content = mock_model(Content, :to_param => 1)
    @comment = mock_model(Comment, :to_param => "1", :user => @current_user, :content => @content)
    @comments = [@comment, @comment]

    controller.stub!(:current_user).and_return(@current_user)
    
    Comment.stub!(:new).and_return(@comment)
    @comment.stub!(:build_content).and_return(@content)

    @content.stub!(:user=)    
    @comment.stub!(:user=)

    @content.stub!(:published=).and_return(true)

    Post.stub!(:find).and_return(@post)
    @post.stub!(:comments).and_return(@comments)
    
    @comment.stub!(:commentable).and_return(@post)
  end
  
  def post_with_successful_save
    @comment.should_receive(:save).and_return(true)
    @content.should_receive(:user=).with(@current_user)
    @content.should_receive(:published=).and_return(true)

    post :create, :comment => {}, :content => {}, :post_id => 1
  end
  
  def post_with_failed_save
    @comment.should_receive(:save).and_return(false)
    
    post :create, :comment => {}, :content => {}, :post_id => 1
  end
  
  it "should create a new comment for a post and redirect back to the post" do  	    
    post_with_successful_save
    
    response.should redirect_to(post_path(1))
  end
  
  it "should create a new comment for a post and populate the flash[:notice]" do
    post_with_successful_save

    flash[:notice].should_not be_empty
  end

  it "should redirect to the post after successful save" do
    post_with_successful_save
    
    response.should redirect_to(post_path(1))
  end
  
  it "should populate flash[:notice] on successful save" do
    post_with_successful_save
    
    flash[:notice].should_not be_empty
  end

  it "should re-direct back to the post on failed save" do
    post_with_failed_save

    response.should redirect_to(post_path(1))
  end
end

describe CommentsController, "handling PUT /posts/1/comments/1" do
  before do
    @post = mock_model(Post, :to_param => 1)
    @comment = mock_model(Comment, :to_param => 1)
    
    @comment.stub!(:commentable).and_return(@post)
    Comment.stub!(:find).and_return(@comment)
  end
  
  def put_with_successful_update
    @comment.should_receive(:update_attributes).and_return(true)
    put :update, :comment => {}, :post_id => 1, :id => 1
  end
  
  def put_with_failed_update
    @comment.should_receive(:update_attributes).and_return(false)
    put :update, :comment => {}, :post_id => 1, :id => 1
  end
  
  it "should find the comment requested" do
    Comment.should_receive(:find).with("1").and_return(@comment)
    put_with_successful_update
  end

  it "should update the found comment" do
    put_with_successful_update
    assigns(:comment).should equal(@comment)
  end

  it "should assign the found comment for the view" do
    put_with_successful_update
    assigns(:comment).should equal(@comment)
  end

  it "should redirect to the comment on successful update" do
    put_with_successful_update
    response.should redirect_to(post_path(1))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe CommentsController, "handling DELETE /posts/1/comments/1" do

  before do
    @post = mock_model(Post, :to_param => 1)
    @comment = mock_model(Comment, :destroy => true)

    Comment.stub!(:find).and_return(@comment)
  end
  
  def do_delete
    delete :destroy, :post_id => 1, :id => 1
  end

  it "should find the comment requested" do
    Comment.should_receive(:find).with("1").and_return(@comment)
    do_delete
  end
  
  it "should call destroy on the found comment" do
    @comment.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the comments list" do
    do_delete
    response.should redirect_to(post_path(1))
  end
end
