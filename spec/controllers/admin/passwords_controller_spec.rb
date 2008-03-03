require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PasswordsController, "#route_for" do
  it "should map {:controller => 'admin/passwords', :action => 'new'} to /admin/passwords/new" do
    route_for(:controller => 'admin/passwords', :action => 'new').should == '/admin/passwords/new'
  end
end

describe Admin::PasswordsController, "handling GET /admin/passwords/new" do
  def do_get
    get :new
  end
  
  it "should render the new template" do
    do_get
    response.should render_template("new")
  end
end

describe Admin::PasswordsController, "handling POST /admin/passwords" do
  before(:each) do
    @user = mock_model(User, :to_param => 1)
    User.stub!(:find_for_forget).and_return(@user)
    @user.stub!(:forgot_password)
    @user.stub!(:save)
  end
  
  def do_post
    post :create, :email => "bryan.ray@datacert.com"
  end
  
  def post_with_invalid_email_address
    User.should_receive(:find_for_forget).and_return(nil)
    do_post
  end
  
  def post_with_valid_email_address
    User.should_receive(:find_for_forget).with("bryan.ray@datacert.com").and_return(@user)
    do_post
  end

  it "should save the user after forgot_password is called" do
    @user.should_receive(:forgot_password)
    @user.should_receive(:save)
    post_with_valid_email_address
  end
  
  it "should set a flash message to let the user know an email has been sent" do
    post_with_valid_email_address
    flash[:notice].should_not be_nil
  end 
  
  it "should redirect back to the login page after the email is sent" do
    post_with_valid_email_address
    response.should redirect_to(login_path)
  end
  
  it "should set a flash notice to let the user know that email address was not found" do
    post_with_invalid_email_address
    flash[:notice].should_not be_nil
  end
  
  it "should render the new template again when it can not find the email address" do
    post_with_invalid_email_address
    response.should render_template("new")
  end
end