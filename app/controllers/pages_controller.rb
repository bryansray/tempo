require 'open-uri'
require 'hpricot'

class PagesController < ApplicationController
  before_filter :login_required, :only => [ :edit, :new ]

  def access_denied
    notify :notice, "You must login to access that page."
    super
  end

  # GET /pages
  # GET /pages.xml
  def index
    @recent_changes = Page.find(:all, :include => :content, :conditions => ["contents.published = ?", true], :limit => 10, :order => "pages.updated_at DESC")
    @visits = Visit.find :all, :conditions => ["contents.owner_type = ?", 'Page'], :include => :content, :group => "content_id", :order => "visits.created_at DESC", :limit => 10
    @tags = Content.tag_counts
    
    if logged_in? && !current_user.default_page.nil?
      redirect_to page_url(current_user.default_page)
    else  
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @pages }
      end
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    if params[:page_id]
      @page = Page.find(params[:page_id])
    else
      @page = Page.find(params[:id])
    end
    
    @comments = @page.comments(:order => "created_at ASC")
    
    @page.content.revert_to!(params[:id]) if params[:page_id]
    
    current_user.visits.create(:user => current_user, :content => @page.content) if logged_in? && @page.published?

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new
    @document = ""
    @title = ""
    if !params[:url].nil? then
      #load openwiki page using Hpricot (http://code.whytheluckystiff.net/hpricot/)
      @document = open(params[:url]) { |f| Hpricot f, :fixup_tags => true }

      #find the title of the OpenWiki page and populate the field for the editor
      title = (@document/"h1 a.same")
      @title = title[0].inner_html unless title[0].nil?

      #fix anchors in the html before extracting the body portion
      (@document/"a").each do |a|
        if !a.attributes["href"].nil?
          #sometimes the link already has the correct url host and protocol
          a.attributes["href"] = "http://dcapp01/openwiki/" + a.attributes["href"] if a.attributes["href"].index( "http" ).nil?
        end
      end

      #now we should be ready to slice out the relevant body text
      @document = (@document/"#TeamPortal").inner_html
    end
	

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])
    content = @page.build_content(params[:content])
    content.published = true if params[:commit] == "Publish"
    content.tag_list.add(params[:tags_to_apply], :parse => true)

    # Set the page owner and content owner
    if (logged_in?)
      @page.user = current_user
      @page.content.user = current_user
    end

    respond_to do |format|
      if @page.save
        notify :notice, 'Page was successfully created.'

        format.html { redirect_to(@page) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])

    # Update the last user that updated the content
    @page.content.user = current_user if logged_in?
    @page.content.published = true if params[:commit] == "Publish"
    @page.tag_list.add(params[:tags_to_apply], :parse => true)
	
    respond_to do |format|
      if @page.update_attributes(params[:page]) && @page.content.update_attributes(params[:content])
        notify :notice, 'Page was successfully updated.'
        
        format.html { redirect_to(@page) }
        format.xml  { head :ok }
        format.js
      else
		    notify :error, "There was an error updating the page."

        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end
  
  def import
    respond_to do |format|
      format.js
    end
  end
  
  def remove_default
    current_user.update_attribute(:default_page, nil)
    
    respond_to do |format|
      format.js
    end
  end
  
  def set_default
    
    current_user.update_attribute(:default_page, params[:id])

    respond_to do |format|
      format.js
    end
  end
end