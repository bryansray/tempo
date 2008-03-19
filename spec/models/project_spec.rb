require File.dirname(__FILE__) + '/../spec_helper'

describe Project, "with fixtures loaded" do
  fixtures :projects, :users, :cards, :taggings, :tags, :properties, :types,
            :members, :teams
  before(:each) do
    @project = projects(:one)
  end

  it "should be valid" do
    @project.should be_valid
  end
  
  it "should not be valid without a name" do
    @project.name = ""
    @project.should_not be_valid
  end
  
  it "should have a page assigned to it"
  
  it "should have multiple properties that belong to it including 'system' level properties" do
    @project.should have(4).properties
  end
  
  it "should have an owner that is in charge of the project" do
    @project.owner.should == users(:one)
  end
  
  it "should have multiple tags" do
    @project.should have(2).tags
  end
  
  it "should have multiple teams that are assigned to the project" do
    @project.should have(2).teams
  end
  
  it "should have multiple users that are working on the project" do
    @project.should have(3).users
  end
  
  it "should have multiple cards" do
    @project.should have(3).cards
  end
  
  it "should have multiple card types" do
    @project.should have(1).card_types
  end
end