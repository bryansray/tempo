require File.dirname(__FILE__) + '/../spec_helper'

describe TagsController, "#route_for" do
  it "{ :controller => 'tags', :action => 'index' } should map to '/tags'" do
    route_for(:controller => "tags", :action => "index").should == "/tags"
  end
  
  it "{ :controller => 'tags', :action => 'show', :id => 1 } should map to /tags/1" do
    route_for(:controller => "tags", :action => "show", :id => 1).should == "/tags/1"
  end
end

describe TagsController, "handling GET /tags" do
  before(:each) do
    @tag = mock_model(Tag, :to_param => 1)
    @tags = [@tag]
    
    Tag.stub!(:find).and_return(@tags)
  end
  
  def do_get
    get :index
  end
  
  it "should assign all the tags to the view" do
    do_get
    assigns[:tags].should == @tags
  end
  
  it "should find the tag_counts for the Content model" do
    Content.should_receive(:tag_counts).and_return(2)
    do_get
  end
end