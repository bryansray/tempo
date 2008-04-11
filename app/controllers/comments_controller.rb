class CommentsController < ApplicationController
#  # GET /comments
#  # GET /comments.xml
#  def index
#    @comments = Comment.find(:all)
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @comments }
#    end
#  end
#
#  # GET /comments/1
#  # GET /comments/1.xml
#  def show
#    @comment = Comment.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @comment }
#    end
#  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /users/1/blogs/1/posts/1/comments
  # POST /users/1/blogs/1/posts/1/comments.xml
  # POST /page/1/comments
  def create
    @comment = Comment.new(params[:comment])
    content = @comment.build_content(params[:content])

    @comment.user = current_user
    @comment.content.user = current_user

    @comment.content.published = true

    if !params[:post_id].nil?
      post = Post.find(params[:post_id])
      post.comments << @comment
    elsif !params[:page_id].nil?
      page = Page.find(params[:page_id])  
      page.comments << @comment
	  elsif !params[:card_id].nil?
      card = Card.find(params[:card_id])  
      card.comments << @comment
    end

    respond_to do |format|
      if @comment.save #post.save && comment.save && content.save
        flash[:notice] = 'Comment was successfully created.'
        
        format.html { redirect_to polymorphic_path(@comment.commentable) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
        format.js
      else
        format.html { redirect_to polymorphic_path(@comment.commentable) }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to polymorphic_path(@comment.commentable) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1/comments/1
  # DELETE /pages/1/comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(post_path(params[:post_id])) }
      format.xml  { head :ok }
      format.js
    end
  end
end
