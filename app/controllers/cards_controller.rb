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
    unless params[:team_id].empty?
      team = Team.find(params[:team_id]) 
      @card.team = team
      @card.project = team.project
    end
    @card.number = Card.next_number(params[:project_id])

    respond_to do |format|
      if @card.save
        format.html { redirect_to project_card_path(@card.project, @card) }
        format.js
      else
        format.html { render :action => "new" }
        format.js { render "error" }
      end
    end
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
    @card = Card.find_by_number(params[:id], :conditions => ["project_id = ?", params[:project_id]])
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
    @card = Card.new(:number => Card.next_number(@project.id))
  end
end
