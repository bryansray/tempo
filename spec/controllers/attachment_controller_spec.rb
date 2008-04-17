require File.dirname(__FILE__) + '/../spec_helper'

describe AttachmentsController, "#route_for" do
  it "should map { :controller => 'attachments', :action => 'index' } to /attachments" do
    route_for(:controller => "attachments", :action => "index").should == "/attachments"
  end
  
  it "should map { :controller => 'attachments', :action => 'new' } to /attachments/new" do
    route_for(:controller => "attachments", :action => "new").should == "/attachments/new"
  end
  
  it "should map { :controller => 'attachments', :action => 'show', :id => 1 } to /attachments/1" do
    route_for(:controller => "attachments", :action => "show", :id => 1).should == "/attachments/1"
  end
  
  it "should map { :controller => 'attachments', :action => 'edit', :id => 1 } to /attachments/1/edit" do
    route_for(:controller => "attachments", :action => "edit", :id => 1).should == "/attachments/1/edit"
  end
 
  it "should map { :controller => 'attachments', :action => 'update', :id => 1} to /attachments/1" do
    route_for(:controller => "attachments", :action => "update", :id => 1).should == "/attachments/1"
  end
  
  it "should map { :controller => 'attachments', :action => 'destroy', :id => 1 } to /attachments/1" do
    route_for(:controller => "attachments", :action => "destroy", :id => 1).should == "/attachments/1"
  end  
end

describe AttachmentsController, "handling POST /attachments" do

  it "should not create the attachment" do
    controller.should_receive(:notify).with( :error, 'Adding attachment failed.' )
    post :create, :attachment => { :content_id => 1 }

    response.should redirect_to(content_path(1))
  end
  
  it "should create the attachment" do
    controller.should_receive(:notify).with( :notice, 'Attachment was successfully added.' )
    post :create, :attachment => { :content_type => 'test', :size => 10.megabytes, :filename => 'test.file', :content_id => 1}

    response.should redirect_to(content_path(1))
  end

end