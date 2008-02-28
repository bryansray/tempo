class ContentsController < ApplicationController
  def index
    @contents = Content.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @contents.to_xml }
    end
  end
	
  def show
    @content = Content.find(params[:id])
    redirect_to polymorphic_path(@content.owner)
  end
	
  def new
    @content = Content.new

    respond_to do |format|
      format.html #new.html.erb
      format.xml { render :xml => @content }
    end
  end
	
  # GET /contents/1;edit
  def edit
    @content = Content.find(params[:id])
    
    respond_to do |format|
      format.js
      format.html #edit.html.erb
    end
  end
  
  def edit_tags
    @content = Content.find(params[:id])
  end
	
  # POST /users
  # POST /users.xml
  def create
    @content = Content.new(params[:content])

    respond_to do |format|
      if @content.save
        flash[:notice] = 'Content was successfully created.'

        format.html { redirect_to(@content) }
        format.xml  { render :xml => @content, :status => :created, :location => @content }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update_tags
    @content = Content.find(params[:id])
    @content.tag_list.remove(@content.tag_list)
    @content.tag_list.add(params[:tags][:name], :parse => true)
    
    respond_to do |format|
      if @content.save
        format.js
      end
    end
  end
  
  # PUT /contents/1
  # PUT /contents/1.xml
  def update
    @content = Content.find(params[:id])

    respond_to do |format|
      if @content.update_attributes(params[:content])
        flash[:notice] = 'Content was successfully updated.'
        format.html { redirect_to content_url(@content) }
        format.xml  { head :ok }
        format.js #
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @content.errors.to_xml }
      end
    end
  end
	
  # DELETE /contents/1
  # DELETE /contents/1.xml
  def destroy
    @content = Content.find(params[:id])
    @content.destroy

    respond_to do |format|
      format.html { redirect_to contents_url }
      format.xml  { head :ok }
    end
  end

  def search
    @results = Content.find_by_contents( params[:terms] ) unless params[:terms].nil?

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @contents.to_xml }
    end
  end
  
  def tag_cloud
    #@tags = Content.tag_count
  end
end
