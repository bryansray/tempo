require File.dirname(__FILE__) + '/../spec_helper'

describe Link do
  fixtures :links, :contents
  before(:each) do
    @link = links(:one) #Link.new
  end

  it "should be valid" do
    @link.should be_valid
  end
  
  it "should have a url function" do
    @link.url.should == links(:one).url #"http://www.gooogle.com"
  end
  
  it "should have a description property that refers to content.text model" do
    @link.description.should == contents(:six).text
  end
  
  it "should have a title property that refers to content.title model" do
    @link.title.should == contents(:six).title
  end

  it "should not be valid if url is empty or nil" do
    @link.url = ""
    @link.should_not be_valid
  end
  
  it "should require a title to be valid" do
    @link.title = ""
    @link.should_not be_valid
  end
end
