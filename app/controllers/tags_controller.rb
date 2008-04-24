class TagsController < ApplicationController
  # GET /tags
  # GET /tags.xml
  def index
    @tags = Content.tag_counts

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /tags/1
  # GET /tags/1.xml
  def show
    @tag = Tag.find params[:id]
    taggings = Tagging.find(:all, :conditions => ["tag_id = ?", params[:id]] )
  	@content = {}
	
  	#group the taggings
  	taggings.each do |tagging|
  		if @content[tagging.taggable_type].nil?
  			@content[tagging.taggable_type] = []
  		end
	
  		@content[tagging.taggable_type] << tagging
  	end
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tags/new.xml
  # GET /tags/new.js
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @tag }
      format.js
    end
  end
  
  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
    
    respond_to do |format|
      format.js
    end
  end

  # POST /tags
  # POST /tags.xml
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        notify :notice, 'Tag was successfully created.'
        format.html { redirect_to(@tag) }
        format.js
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.xml
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        notify :notice, 'Tag was successfully updated.'
        format.html { redirect_to(@tag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.xml
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to(tags_url) }
      format.xml  { head :ok }
    end
  end
end
