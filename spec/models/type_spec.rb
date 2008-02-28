require File.dirname(__FILE__) + '/../spec_helper'

describe Type do
  fixtures :types, :card_types, :cards, :projects
  
  before(:each) do
    @type = types(:one) #Type.new
  end

  it "should be valid" do
    @type.should be_valid
  end
  
  it "should have many cards associated with it" do
    @type.should have(1).cards
  end
  
  it "should not be valid without a name" do
    @type.name = nil
    @type.should_not be_valid
  end
  
  it "should belong to a specific project" do
    @type.project.should eql(projects(:one))
  end
end
