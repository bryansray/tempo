require File.dirname(__FILE__) + '/../spec_helper'

describe Team, "with fixtures loaded" do
  fixtures :teams, :members, :users, :iterations, :projects
  
  before(:each) do
    @team = teams(:one) #Team.new
  end

  it "should be valid" do
    @team.should be_valid
  end
  
  it "should have members who are currently on the team" do
    @team.should have(2).members
  end
  
  it "should have multiple iterations" do
    @team.should have(2).iterations
  end
  
  it "should have multiple members assigned to it" do
    @team.should have(2).members
  end
  
  it "should have users who members of this team" do
    @team.should have(2).users
  end
  
  it "should have multiple cards assigned to it" do
    @team.should have(1).cards
  end
  
  it "should be assigned to a specific project" do
    @team.project.should eql(projects(:one))
  end
end
