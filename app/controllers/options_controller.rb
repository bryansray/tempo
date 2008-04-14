class OptionsController < ApplicationController
  # GET /options
  # GET /options.xml
  def index
    if !params[:property_id].nil?
		@property = Property.find(params[:property_id])
		@options = @property.options.find( :all, :order => "sequence" )
	else
		@options = Option.find(:all)
	end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @options }
    end
  end

  # GET /options/1
  # GET /options/1.xml
  def show
    @option = Options.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @option }
    end
  end

  # GET /options/new
  # GET /options/new.xml
  def new
    @option = Option.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @option }
    end
  end

  # GET /options/1/edit
  def edit
    @option = Option.find(params[:id])
  end

  # POST /options
  # POST /options.xml
  def create
	count = Property.find(params[:property_id]).options.count
	params[:option][:property_id] = params[:property_id]
	params[:option][:sequence] = count
    @option = Option.create(params[:option])
	@property_id = params[:property_id]
  end
  
  def update_order
	params[:vallist].each_index do |i|
		@v = Option.find(params[:vallist][i])
		@v.sequence = i
		@v.save
	end
	@msg = "Order changed."
	
	render :partial => "update_order"
  end
  
  def set_default
	@property = Property.find(params[:property_id])
	@property.default_option = params[:id]
	@property.save
  end

  # PUT /options/1
  # PUT /options/1.xml
  def update
    @option = Option.find(params[:id])

    respond_to do |format|
      if @option.update_attributes(params[:option])
        notify :notice, 'Option was successfully updated.'
        format.html { redirect_to(@option) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @option.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /options/1
  # DELETE /options/1.xml
  def destroy
    @option = Option.find(params[:id])
    @option.destroy

    respond_to do |format|
      format.html { redirect_to(options_url) }
      format.xml  { head :ok }
    end
  end
end
