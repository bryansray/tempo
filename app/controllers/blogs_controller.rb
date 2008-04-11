class BlogsController < ApplicationController	
  # GET /blogs
  # GET /blogs.xml
  def index
    @posts = Post.find_published(:all, :limit => 10, :order => "contents.published_at DESC")
    @tags = Content.tag_counts
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /users/1/blogs/1
  # GET /blogs/1.xml
  def show
	@blog = Blog.find(params[:id])
	@posts = @blog.posts
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/new
  # GET /blogs/new.xml
  def new
    @blog = Blog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/1/edit
  def edit
    @blog = Blog.find(params[:id])
  end

  # POST /blogs
  # POST /blogs.xml
  def create
  	@blog = current_user.blogs.build(params[:blog])
    
    respond_to do |format|
		if current_user.save
			flash[:notice] = 'Blog was successfully created.'
			format.html { redirect_to blog_path(@blog) }
			format.xml  { render :xml => @blog, :status => :created, :location => @blog }
		else
			format.html { render :action => "new" }
			format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
		end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
    @blog = Blog.find(params[:id])
    
    respond_to do |format|
      # TODO : Not entirely sure this is the best way to do this
      if @blog.update_attributes(params[:blog])
        flash[:notice] = 'Blog was successfully updated.'
        format.html { redirect_to blog_url(@blog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.xml
  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to(blogs_url) }
      format.xml  { head :ok }
    end
  end
end