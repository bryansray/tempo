require File.dirname(__FILE__) + '/../spec_helper'

describe Department do
  before(:each) do
    @department = Department.new
  end

  it "should be valid" do
    @department.should be_valid
  end
end
