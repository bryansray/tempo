require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  fixtures :pages, :contents, :users, :taggings, :tags
	
  before(:each) do
    @page = pages(:one) #Page.new
  end
  
  it "should have a text property that returns content.text" do
    @page.text.should == contents(:five).text
  end
  
  it "should have a text property that will set content.text" do
    @page.text = "Testing"
    @page.text.should == "Testing"
  end
  
  it "should have a title property that returns content.title" do
    @page.title.should == contents(:five).title  
  end
  
  it "should have a title property that will set the content.title" do
    @page.title = "Title"
    @page.title.should == "Title"
  end

  it "should have a published? property that will return whether or not the page is published" do
    @page.should_not be_published
  end
  
  it "should have a tags property that refers to a content.tags" do
    @page.should have(2).tags
  end
  
  it "should have a tag_list property that refers to a content.tag_list" do
	@page.should have(1).tag_list
  end

  it "should be valid" do
    @page.should be_valid
  end
  
  it "should have content" do
    @page.content.should == contents(:five)
  end
  
  it "should be created by a user" do
    @page.user.should == users(:one)
  end

  it "should return false for deprecated?" do
    @page.deprecated?.should == false
  end
  
  it "should have many visits"
end