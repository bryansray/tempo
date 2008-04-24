class PostsController < ApplicationController
  before_filter :login_required, :only => [:edit, :new]
  
  def authorized?
    if action_name == "edit"
      post = Post.find(params[:id])
      current_user.id == post.user.id
    elsif action_name == "new"
      logged_in?
    end
  end
  
  def access_denied
    notify :notice, "Login is required."
    store_location
    redirect_to login_path
  end
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.find(:all, :order => "created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    if params[:post_id]
      @post = Post.find(params[:post_id])
    else
      @post = Post.find(params[:id])
    end
    
    @comments = @post.comments(:order => "created_at ASC")
    @versions = @post.versions.find(:all, :limit => 5, :order => "updated_at DESC")
    
    @post.content.revert_to!(params[:id]) if params[:post_id]

    current_user.visits.create(:user => current_user, :content => @post.content) if logged_in? && @post.published?
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @post }
      format.js
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end 
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @content = @post.content
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(:user_id => params[:user_id], :blog => current_user.blogs[0], :user => current_user)
    content = @post.build_content(params[:content])
    content.published = true if params[:commit] == "Publish"
    content.published_at = DateTime.now
    content.user = current_user

    respond_to do |format|
      if @post.save
        notify :notice, 'Post was successfully created.'
        format.html { redirect_to post_path(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1/blogs/1/posts/1
  # PUT /users/1/blogs/1/posts/1.xml
  def update
    @post = Post.find(params[:id])
    @post.content.user = current_user
    
    if params[:commit] == "Publish"
      @post.content.published = true 
      @post.content.published_at = DateTime.now
    end
    
    @post.tag_list.add(params[:tags_to_apply], :parse => true)
    
    respond_to do |format|
      if @post.update_attributes(params[:post]) && @post.content.update_attributes(params[:content])
        notify :notice, 'Post was successfully updated.'

        format.html { redirect_to post_path(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
