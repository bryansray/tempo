class IterationsController < ApplicationController
  # GET /iterations
  # GET /iterations.xml
  def index
    if !params[:team_id].nil?
		@team = Team.find(params[:team_id])
		@iterations = @team.iterations
	else
		@iterations = Iteration.find(:all)
	end
  end

  # GET /iterations/1
  # GET /iterations/1.xml
  def show
    @iteration = Iteration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @iteration }
    end
  end

  # GET /iterations/1/edit
  def edit
    @iteration = Iteration.find(params[:id])
  end

  # POST /iterations
  # POST /iterations.xml
  def create
	@team = Team.find(params[:team_id])
	@iteration = @team.iterations.create( params[:iteration] )
  end

  # PUT /iterations/1
  # PUT /iterations/1.xml
  def update
    @iteration = Iteration.find(params[:id])

    respond_to do |format|
      if @iteration.update_attributes(params[:iteration])
        notify :notice, 'Iteration was successfully updated.'
        format.html { redirect_to(@iteration) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@iteration) }
        format.xml  { render :xml => @iteration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /iterations/1
  # DELETE /iterations/1.xml
  def destroy
    @iteration = Iteration.find(params[:id])
    @iteration.destroy

    respond_to do |format|
      format.html { redirect_to(iterations_url) }
      format.xml  { head :ok }
    end
  end
end
