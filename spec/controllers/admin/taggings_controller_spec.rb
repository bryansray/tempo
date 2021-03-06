require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::TaggingsController, "handling DELETE /admin/taggings/1" do
  before(:each) do
    @content = mock_model(Content)
    @tagging = mock_model(Tagging, :to_param => 1)
    
    Tagging.stub!(:find).and_return(@tagging)
    @tagging.stub!(:taggable).and_return(@content)
    @tagging.stub!(:destroy)
  end
  
  def do_delete
    delete :destroy, :id => 1
  end

  it "should be successful" do
    do_delete
    response.should be_success
  end
  
  it "should assign the taggable object to the associated view" do
    do_delete
    assigns[:object].should == @content
  end
  
  it "should find the tagging that was requested" do
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
    post :create, :applicator => { :id => '1', :class => 'Content' }, :tag => { :name => "Tag 1" }
  end
  
  def post_with_successfully_saving_tags
    @content.should_receive(:save_tags).and_return(true)
    do_post
  end
  
  it "should be successful" do
    post_with_successfully_saving_tags
    response.should be_success
  end
  
  it "should assign the taggable object to the associated view" do
    post_with_successfully_saving_tags
    assigns[:object].should == @content
  end
  
  it "should find the taggable type by the taggable id" do
    Content.should_receive(:find).with('1').and_return(@content)
    post_with_successfully_saving_tags
  end
  
  it "should add the new tags to the taggable type" do
    @tag_list.should_receive(:add).with("Tag 1", :parse => true).and_return(@tag_list)
    post_with_successfully_saving_tags
  end
end