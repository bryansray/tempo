class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all)
    @contents = Content.find(:all, :limit => 10, :order => "updated_at DESC")
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @contents = @user.contents.find(:all, :conditions => ['published = ?', true], :limit => 15, :order => "updated_at DESC")
    
    if current_user == @user
      @posts = @user.blogs[0].posts 
      @pages = @user.pages
    else
      @posts = @user.blogs[0].published_posts
      @pages = @user.published_pages
    end

    @visits = Visit.find(:all, :select => "id, user_id, content_id, count(*) as 'count'", :conditions => ["user_id = ?", @user.id], :limit => 10, :group => "content_id", :order => "MAX(created_at) DESC")
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.blogs.build(:name => "Default", :description => "Blog about current issues you're working on", :allow_comments => true, :user => @user)
	
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        self.current_user = @user
        
        format.html { redirect_to user_path(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def change_password
    return unless request.post?
  end
  
  def reset_password
    if params[:id].nil?
      render :action => "new"
      return
    end
    
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @user.nil?
  rescue
    logger.error "Invalid Reset Code entered."
    flash[:notice] = "Sorry - That is an invalid password reset code. Please check your code and try again. (Perhaps your email client inserted a carriage return?)"
  end
  def forgot_password
    return unless request.post?
    
    if @user = User.find_by_email(params[:user][:email])
      @user.forgot_password
      @user.save
      Notifier.deliver_forgot_password(@user)
      flash[:notice] = "A password reset link has been sent to your email address"
      
      redirect_back_or_default('/')
    else
      flash[:warning] = "Could not find a user with that email address"
    end
  end
end
