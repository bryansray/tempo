class CardTypesController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
  end

  def show
  end
  
  def edit
    @project = Project.find(params[:project_id])
    @card_type = Type.find(params[:id])
  end
  
  def new
    @project = Project.find(params[:project_id])
    @card_type = Type.new
  end
  
  def create
    @project = Project.find(params[:project_id])
    @card_type = @project.card_types.build(params[:card_type])
    
    respond_to do |format|
      if @card_type.save
        notify :notice, "Card type was successfully created"
        format.html { redirect_to(project_card_types_path(@project)) }
      end
    end
  end
  
  def update
    
  end
end
