require File.dirname(__FILE__) + '/../spec_helper'

describe ContentsController, "#route_for" do

  it "should map { :controller => 'contents', :action => 'index' } to /contents" do
    route_for(:controller => "contents", :action => "index").should == "/contents"
  end
  
  it "should map { :controller => 'contents', :action => 'new' } to /contents/new" do
    route_for(:controller => "contents", :action => "new").should == "/contents/new"
  end
  
  it "should map { :controller => 'contents', :action => 'show', :id => 1 } to /contents/1" do
    route_for(:controller => "contents", :action => "show", :id => 1).should == "/contents/1"
  end
  
  it "should map { :controller => 'contents', :action => 'edit', :id => 1 } to /contents/1/edit" do
    route_for(:controller => "contents", :action => "edit", :id => 1).should == "/contents/1/edit"
  end
  
  it "should map { :controller => 'contents', :action => 'update', :id => 1} to /contents/1" do
    route_for(:controller => "contents", :action => "update", :id => 1).should == "/contents/1"
  end
  
  it "should map { :controller => 'contents', :action => 'destroy', :id => 1} to /contents/1" do
    route_for(:controller => "contents", :action => "destroy", :id => 1).should == "/contents/1"
  end
  
end

describe ContentsController, "handling GET /contents/1 associated with a page" do
  before do
    @content = mock_model(Content)
	@page = mock_model(Page, :to_param => 1)
	@content.stub!(:owner).and_return(@page)
    Content.stub!(:find).and_return(@content)
  end
  
  def do_get
    get :show, :id => 1
  end

  it "should be redirected" do
    do_get
    response.should be_redirect
  end
  
  it "should redirect to page the content is associated with" do
	do_get
	response.should redirect_to(page_path(@page))
  end
end

describe ContentsController, "handling GET /contents/1 associated with a post" do
  before do
    @content = mock_model(Content)
	@post = mock_model(Post, :to_param => 1)
	@content.stub!(:owner).and_return(@post)
    Content.stub!(:find).and_return(@content)
  end
  
  def do_get
    get :show, :id => 1
  end

  it "should be redirected" do
    do_get
    response.should be_redirect
  end
  
  it "should redirect to page the content is associated with" do
	do_get
	response.should redirect_to(post_path(@post))
  end
end