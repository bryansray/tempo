class CardsController < ApplicationController  
  def index
    @lanes = []

    # TODO : "Status" should be set as a 'default' value in the database rather than hard coded.
    if params[:group_by]
      @property = Property.find(params[:group_by][:property_id], :order => "options.sequence", :include => :options)
    else
      @property = Property.find_by_name("Status", :order => "options.sequence", :include => :options)
    end

    if params[:team_id]
      @team = Team.find(params[:team_id])
      @project = @team.project
    else
      @project = Project.find(params[:project_id]) if params[:project_id]
    end
      
    card_ids = []
    @property.options.each do |option|
      if @team
        conditions = ["cards.team_id = ? AND card_properties.option_id = ?", @team.id, option.id]
      else
        conditions = ["cards.project_id = ? AND card_properties.option_id = ?", @project.id, option.id]
      end
      
      cards = Card.find(:all, :conditions => conditions, :include => :card_properties)
      cards.collect{ |card| card_ids << card.id }
      @lanes << [option, *cards]
    end

    # FIXME : Yuck ...
    if card_ids.length > 0
      if @team
        conditions = ["cards.project_id = ? AND cards.team_id = ? AND (card_properties.card_id NOT IN (?) OR card_properties.card_id IS NULL)", @project.id, @team.id, card_ids]
      else
        conditions = ["cards.project_id = ? AND (card_properties.card_id NOT IN (?) OR card_properties.card_id IS NULL)", @project.id, card_ids]
      end
      
      cards = Card.find(:all, :conditions => conditions, :include => :card_properties)
    else
      if @team
        conditions = ["cards.project_id = ? AND cards.team_id = ?", @project.id, @team.id]
      else
        conditions = ["cards.project_id = ?", @project.id]
      end
      cards = Card.find(:all, :conditions => conditions, :include => :card_properties)
    end
      
    @lanes.unshift([Option.new(:name => "(not set)", :sequence => 0), *cards])
  end
  
  def create
    @card = Card.new(params[:card])
    
    @card.project = Project.find(params[:project_id]) if params[:project_id]
    @card.team = Team.find(params[:team_id]) if params[:team_id]

    respond_to do |format|
      if @card.save
        format.html { redirect_to project_card_path(@card.project, @card) }
        format.js
      else
        format.html { render :action => "new" }
        format.js { render "error" }
      end
    end
#    if @card.save?
#      props = Property.find(:all, :conditions => "scope_id IS NULL")
#      props += @card.team.properties if @card.team_id
#      props += @card.iteration.properties if @card.iteration_id
#      props += @card.project.properties if @card.project_id
#
#      props.each do |prop|
#        CardProperty.create( :card_id => @card.id, :property_id => prop.id, :option_id => prop.default_option )
#      end
#    end
  end
   
  def change_iteration
  	@card = Card.find(params[:id])
	@card.iteration_id = params[:iteration_id]
	@card.save
  end
  
  def change_actual
  	@card = Card.find(params[:id])
	@card.actual = params[:actual]
	@card.save
  end
  
  def change_estimated
  	@card = Card.find(params[:id])
	@card.estimated = params[:estimated]
	@card.save
  end
  
  def show
    @card = Card.find(params[:id])
  end
  
  def edit
	@card = Card.find(params[:id])
  end
  
  def update
    @card = Card.find(params[:id])

    respond_to do |format|
      if @card.update_attributes(params[:card])
        flash[:notice] = 'Card was successfully updated.'
        format.html { redirect_to(@card) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def new
    @project = Project.find(params[:project_id]) if params[:project_id]
    @card = Card.new
  end
end
