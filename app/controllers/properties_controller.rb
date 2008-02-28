class PropertiesController < ApplicationController
  # GET /properties
  # GET /properties.xml
  def index
    @properties = Property.find(:all, :conditions => "scope_type = 'Project'")
	@property = Property.new
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @properties }
    end
  end

  # GET /properties/1
  # GET /properties/1.xml
  def show
    @property = Property.find(params[:id])
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @property }
      format.js { render :json => @property.to_json }
    end
  end

  # GET /properties/new
  # GET /properties/new.xml
  def new
    @property = Property.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @property }
    end
  end

  # GET /properties/1/edit
  def edit
    @property = Property.find(params[:id])
  end

  # POST /properties
  # POST /properties.xml
  def create
    @property = Property.create(params[:property])
	if @property.valid?
		# the assumption here is that this is a system level property
		# so all cards get it, scope level property creation is done at the model level
		# e.g. A property for teams is added via the TeamController.add_property action
		Card.find(:all).each do |card|
			CardProperty.create( :card_id => card.id, :property_id => @property.id, :option_id => @property.default_option )
		end
	end
  end

  # PUT /properties/1
  # PUT /properties/1.xml
  def update
    @property = Property.find(params[:id])

    respond_to do |format|
      if @property.update_attributes(params[:property])
        flash[:notice] = 'Property was successfully updated.'
        format.html { redirect_to(@property) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @property.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.xml
  def destroy
    @property = Property.find(params[:id])
    @property.destroy

    respond_to do |format|
      format.html { redirect_to(properties_url) }
      format.xml  { head :ok }
    end
  end
  
  def change_option
	@card_prop = CardProperty.find( :first, :conditions => ["card_id = ? and property_id = ?", params[:card_id], params[:id]])
	@card_prop.option_id = params[:option_id]
	@card_prop.save
  end
end
