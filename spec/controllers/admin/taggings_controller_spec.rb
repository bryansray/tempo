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

describe Admin::TaggingsController, "handling POST /admin/taggings" do
  before(:each) do
    @content = mock_model(Content, :to_param => 1)    
    @tag_list = mock_model(TagList)
    Content.stub!(:find).and_return(@content)
    @content.stub!(:tag_list).and_return(@tag_list)
    @tag_list.stub!(:add).and_return(@tag_list)
  end
  
  def do_post
    post :create, :id => 1, :tags => { :taggable_type => 'Content', :tag_list => "Tag 1" }
  end
  
  def post_with_successful_save
    @content.should_receive(:save).and_return(true)
    do_post
  end
  
  it "should be successful" do
    post_with_successful_save
    response.should be_success
  end
  
  it "should find the taggable type" do
    Content.should_receive(:find).with('1').and_return(@content)
    post_with_successful_save
  end
  
  it "should add the new tags to the taggable type" do
    @tag_list.should_receive(:add).with("Tag 1", :parse => true).and_return(@tag_list)
    post_with_successful_save
  end
end