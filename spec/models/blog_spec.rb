require File.dirname(__FILE__) + '/../spec_helper'

describe Blog, "with fixtures loaded" do
	fixtures :blogs, :users, :posts, :contents
	
  before(:each) do
  	@blog = blogs(:one)
  end
  
  it "should be valid" do
  	@blog.should be_valid
  end	
  	
  it "should belong to a specific user" do
  	@blog.user.should == users(:one)
  end
  
  it "should have two posts" do
  	@blog.should have(2).posts
  end
  
  it "should not be valid without a name" do
  	@blog.name = nil
  	
  	@blog.should_not be_valid
  end
end
