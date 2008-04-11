require File.dirname(__FILE__) + '/../spec_helper'

require 'comment'

describe Comment, "with fixtures loaded" do
  fixtures :comments, :users, :contents
  
  before(:each) do
    @comment = comments(:one)
  end

  it "should be valid" do
    @comment.should be_valid
  end
    
  it "should belong to a piece of content" do
    @comment.content.should eql(contents(:four))
  end
    
  it "should belong to a user" do
    @comment.user.should eql(users(:one))
  end
  
  it "should have a title method that delegates to its content association" do
    @comment.title.should == contents(:four).title
  end
  
  it "should have a text method that delegates to its content association" do
    @comment.text.should == contents(:four).text
  end
end
