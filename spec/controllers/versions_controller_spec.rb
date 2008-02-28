require File.dirname(__FILE__) + '/../spec_helper'

describe VersionsController, "handling GET /contents/:content_id/versions" do
  before(:each) do
    @content = mock_model(Content, :to_param => 1)
    @version = mock_model(Content, :to_param => 1)
    @versions = [@version]
    
    Content.stub!(:find).and_return(@content)
    @content.stub!(:versions).and_return(@versions)
    @versions.stub!(:find).and_return(@versions)
  end
  
  def do_get
    get :index, :content_id => 1
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
end