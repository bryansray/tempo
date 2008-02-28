require File.dirname(__FILE__) + '/../spec_helper'

describe CardType, "with fixtures loaded" do
  fixtures :projects, :cards, :card_types, :types

  before(:each) do
    @card_type = card_types(:one)
  end

  it "should be valid" do
    @card_type.should be_valid
  end
  
  it "should belong to a specific card"
  it "should belong to a specific type"
  it "should belong to a specific project"
end
