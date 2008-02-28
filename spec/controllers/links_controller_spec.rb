require File.dirname(__FILE__) + '/../spec_helper'

describe LinksController, "#route_for" do
  
end

describe LinksController, "handling POST /links" do
  before(:each) do
    @current_user = mock_model(User, :to_param => 1)
    @link = mock_model(Link, :to_param => 1)
    @content = mock_model(Content, :to_param => 1)
    
    Link.stub!(:new).and_return(@link)
    @link.stub!(:content).and_return(@content)
    @content.stub!(:published=).and_return(true)
  end
  
  def do_post
    post :create, :link => {}
  end
  
  def post_with_successful_save
    @link.should_receive(:content).and_return(@content)
    @link.should_receive(:save).and_return(true)
    do_post
  end
  
  def post_with_unsuccessful_save
    @link.should_receive(:save).and_return(false)
    do_post
  end

  it "should create a new link" do
    Link.should_receive(:new).and_return(@link)
    post_with_successful_save
  end
end
