require File.dirname(__FILE__) + '/../spec_helper'

describe Member, "with fixtures loaded" do
  fixtures :members, :teams, :users, :projects
  
  before(:each) do
    @member = members(:one)
  end

  it "should belong to a team" do
    @member.team.should eql(teams(:one))
  end
  
  it "should have a user that is the member of the team" do
    @member.user.should eql(users(:one))
  end
  
  it "should be assigned to work on a project" do
    @member.project.should eql(projects(:one))
  end
  
  it "should be valid" do
    @member.should be_valid
  end
end
