require File.dirname(__FILE__) + '/../spec_helper'

describe CardProperty, "with fixtures loaded" do
  fixtures :card_properties, :cards, :properties, :options
  
  before(:each) do
    @card_property = card_properties(:one)
  end

  it "should be valid" do
    @card_property.should be_valid
  end
  
  it "should belong to a specific property" do
    @card_property.property.should eql(properties(:status))
  end
  
  it "should belong toa  specific card" do
    @card_property.card.should eql(cards(:one))
  end
  
  it "should have a specific option set for this card property" do
    @card_property.option.should eql(options(:open))
  end
end
