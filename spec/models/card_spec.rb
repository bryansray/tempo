require File.dirname(__FILE__) + '/../spec_helper'

describe Card, "with fixtures loaded" do
  fixtures :cards, :card_types, :types, :projects, :taggings, :tags, 
    :properties, :card_properties, :iterations, :teams, :users
  
  before(:each) do
    @card = cards(:one)
    @project = projects(:one)
  end

  it "should be valid" do
    @card.should be_valid
  end
  
  it "should have a number that applies to the card" do
    @card.number.should == cards(:one).number
  end
  
  it "should calculate the next number in the sequence" do
    Card.next_number(@project.id).should == 4
  end
  
  it "should return the number rather than to_param" do
    @card.to_param.should == 1
  end
  
  it "should not be valid without a title" do
    @card.title = nil
    @card.should_not be_valid
  end
  
  it "should have a description method that returns the text method of the associated content" do
    @card.description.should == @card.content.text
  end
  
  it "should have a title that returns the title method of the associated content" do
    @card.title.should == @card.content.title
  end
  
  it "should be valid without a description" do
    @card.description = nil
    @card.should be_valid
  end
  
  it "should have many types" do
    @card.should have(2).types
  end
  
  it "should only belong to one project" do
    @card.project.should == projects(:one)
  end
  
  it "should belong to an iteration" do
    @card.iteration.should eql(iterations(:one))
  end
  
  it "should belong to a specific team" do
    @card.team.should eql(teams(:one))
  end
  
  it "should have tags associated with it" do
    @card.should have(2).tags
  end
  
  it "should have multiple properties associated with it" do
    @card.should have(2).properties
  end
  
  it "should report a status" do
    @card.status.should == "Open"
  end
  
  it "should get user from content" do
    @card.user.should == users(:two)
  end
  
  it "should return '' if content user is null" do
    @card.content.user = nil
    @card.user.should == ''
  end
  
  it "should save the default properties before it is created in the database"
end
