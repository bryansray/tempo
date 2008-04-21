require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::TaggingsController, "handling DELETE /admin/taggings/1" do
  before(:each) do
    @tagging = mock_model(Tagging, :to_param => 1)
    
    Tagging.stub!(:find).and_return(@tagging)
    @tagging.stub!(:destroy)
  end
  
  def do_delete
    delete :destroy, :id => 1
  end

  it "should be successful" do
    do_delete
    response.should be_success
  end
  
  it "should find the taggings that was requested" do
    Tagging.should_receive(:find).with('1').and_return(@tagging)
    do_delete
  end
  
  it "should destroy the associated tagging" do
    @tagging.should_receive(:destroy).and_return(true)
    do_delete
  end
end
