require File.dirname(__FILE__) + '/../spec_helper'

describe Option, "with fixtures loaded" do
  fixtures :options, :properties
  
  before(:each) do
    @option = options(:open)
  end

  it "should be valid" do
    @option.should be_valid
  end
  
  it "should belong to a specific property" do
    @option.property.should eql(properties(:status))
  end
  
  it "should return the name of the property when calling to_s" do
    @option.to_s.should eql(options(:open).name)
  end
end
