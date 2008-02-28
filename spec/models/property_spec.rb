require File.dirname(__FILE__) + '/../spec_helper'

describe Property, "with fixtures loaded" do
  fixtures :projects, :properties, :cards, :card_properties, :options
  
  before(:each) do
    @property = properties(:status) #Property.new
  end
  
  it "should be valid" do
    @property.should be_valid
  end
  
  it "should not be valid without a name" do
    @property.name = nil
    @property.should_not be_valid
  end
  
  it "should be assigned to multiple cards" do
    @property.should have(3).cards
  end
  
  it "should have multiple options assigned to it" do
    @property.should have(2).options
  end
end
