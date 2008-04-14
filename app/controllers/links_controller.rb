class LinksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def index
    @links = Link.find(:all, :order => "position")
  end
  
  def show
    @link = Link.find(params[:id])
  end
  
  def edit
    @link = Link.find(params[:id])
  end
  
  def new
    @link = Link.new
    
    respond_to do |format|
      format.html
      format.js { render :partial => "links/form.html.erb", :layout => false }
    end
  end
  
  def create
    @link = Link.new(:url => params[:link_url], :title => params[:content_title], :description => params[:content_text])
    @link.user = @link.content.user = current_user if (logged_in?)
    @link.content.published = true
    
    
    respond_to do |format|
      if @link.save
        format.js { render :json => { :success => true } }
      else
        format.html
        format.js { render :json => { :success => false, :errors => @link.errors  } }
      end
    end
  end
  
  def update
    @link = Link.find(params[:id])
    
    @link.url = params[:link][:url]
    @link.title = params[:link][:title]
    @link.description = params[:link][:description]
    @link.position = params[:link][:position]
    
    respond_to do |format|
      if @link.save
        notify :notice, 'Link was successfully updated.'
        format.html { redirect_to(@link) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    
  end
end
