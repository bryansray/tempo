class TeamsController < ApplicationController
  # GET /teams
  # GET /teams.xml
  def index
    @teams = Team.find(:all)
	
	respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.find(params[:id])
    @cards = @team.cards :all, :limit => 10

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @team = Team.new
    @project = Project.find(params[:project_id]) if params[:project_id]

    # TODO : This should find a list of users that can be assigned to the team
    #@users = User.find(:all, :select => "first_name, last_name, CONCAT(first_name, ' ', last_name) as 'member'", :order => "first_name")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # GET /teams/1/edit_users
  def edit_users
    @team = Team.find(params[:id])
    @non_members = User.find(:all).delete_if {|x| @team.users.include?( x ) }
  end
  
  # POST /teaams
  # POST /teams.xml
  def update_users
	@team = Team.find(params[:id])
	current_user_ids = @team.members.collect { |u| u.user_id }
	
	if params[:members].nil?
		@msg = "All members removed from team."
		@team.members.delete_all()
	else
		desired_user_ids = params[:members].collect { |str| str.to_i }
		new_user_ids = desired_user_ids - current_user_ids #this results in an array of user_ids that needs to be added
		old_user_ids = current_user_ids - desired_user_ids #this results in an array of user_ids that need to be removed
		
		new_user_ids.each do |user_id|
			@team.members.create( :team_id => params[:id], :user_id => user_id )
		end
		
		@team.members.each do |member|
			if old_user_ids.include?(member.user_id)
				@team.members.delete(member)
			end
		end
		
		@msg = "Member list updated."
	end
	
	if !@team.save
		@msg = "Member change failed."
	end
	render :partial => "update_users"
  end
  
  def add_property
	@team = Team.find(params[:id])
	@property = @team.properties.build(params[:property])

	if @team.save
		@team.cards.each do |card|
			CardProperty.create( :card_id => card.id, :property_id => @property.id )
		end
	end
	render :template => "properties/create"
  end
  
  # POST /projects/1/teams
  def create
    @team = Team.new(params[:team])
    @project = Project.find(params[:project_id]) if params[:project_id]

    @team.project = @project
    
    respond_to do |format|
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        format.html { redirect_to project_team_path(@project, @team) }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        format.html { redirect_to(@team) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(teams_url) }
      format.xml  { head :ok }
    end
  end
end
