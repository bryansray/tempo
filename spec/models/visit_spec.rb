require File.dirname(__FILE__) + '/../spec_helper'

describe Visit do
  fixtures :visits, :users, :contents
  
  before(:each) do
    @visit = visits(:one) # users(:one) # Visit.new
  end

  it "should be valid" do
    @visit.should be_valid
  end
  
  it "should have a user who visited" do
    @visit.user.should == users(:one)
  end
  
  it "should have a piece of content thatw as visited" do
    @visit.content.should == contents(:one)
  end
end
