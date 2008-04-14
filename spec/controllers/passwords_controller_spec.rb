require File.dirname(__FILE__) + '/../spec_helper'

describe PasswordsController, "#route_for" do
  it "should map {:controller => 'passwords', :action => 'new'} to /forgot_password" do
    route_for(:controller => 'passwords', :action => 'new').should == '/forgot_password'
  end
end

describe PasswordsController, "handling GET /passwords/new" do
  def do_get
    get :new
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render the new template" do
    do_get
    response.should render_template("new")
  end
end

describe PasswordsController, "handling PUT /passwords/1" do
  before(:each) do
    @user = mock_model(User, :to_param => 1)
    User.stub!(:find_by_password_reset_code).and_return(@user)
    @user.stub!(:password_confirmation=)
    @user.stub!(:password=)
    @user.stub!(:reset_password)
  end
  
  def do_put
    put :update, :id => 1, :password => "password", :password_confirmation => "password"
  end
  
  def post_with_successful_save
    @user.should_receive(:save).and_return(true)
    do_put
  end
  
  def post_with_mismatched_passwords
    put :update, :id => 1, :password => "password", :password_confirmation => "mismatched_password"
  end
  
  it "should re-render the 'edit' template if the password is not provided" do
    put :update, :id => 1, :password => ""
    response.should render_template("edit")
  end
  
  it "should redirect to the login page on successful password reset" do
    post_with_successful_save
    response.should redirect_to(login_path)
  end
  
  it "should set a flash variable if a new password is not provided" do
    post_with_successful_save
    flash[:notice].should_not be_nil
  end
  
  it "should render the edit template if a new password is not provided" do
    put :update, :id => 1, :password => ""
    response.should render_template('edit')
  end
  
  it "should set a flash notice if the passwords do not match" do
    post_with_mismatched_passwords
    flash[:notice].should_not be_nil
  end
  
  it "should render the edit template again if the passwords do not match" do
    post_with_mismatched_passwords
    response.should render_template("edit") 
  end
  
  it "should find the user by their password reset code" do
    User.should_receive(:find_by_password_reset_code).and_return(@user)
    post_with_successful_save
  end
  
  it "should set the users password confirmation" do
    @user.should_receive(:password_confirmation=)
    post_with_successful_save
  end
  
  it "should set the users password" do
    @user.should_receive(:password=)
    post_with_successful_save
  end
  
  it "should call the reset password method for the user" do
    @user.should_receive(:reset_password)
    post_with_successful_save
  end
  
  it "should set a flash message letting the user know if their password was reset or not" do
    post_with_successful_save
    flash[:notice].should_not be_empty
  end
end

describe PasswordsController, "handling GET /reset_password/1" do
  before(:each) do
    @user = mock_model(User, :to_param => 1)
    User.stub!(:find_by_password_reset_code).and_return(@user)
  end
  
  def do_get
    get :edit, :id => 1
  end
  
  it "should find the user by the id code that was passed in" do
    User.should_receive(:find_by_password_reset_code).and_return(@user)
    do_get
  end
  
  it "should assign the user to the associated view" do
    do_get
    assigns[:user].should == @user
  end
  
  it "should render the edit template" do
    do_get
    response.should render_template("edit")
  end
  
  it "should should be successful" do
    do_get
    response.should be_success
  end
end

describe PasswordsController, "handling POST /passwords" do
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
    flash[:error].should_not be_nil
  end
  
  it "should render the new template again when it can not find the email address" do
    post_with_invalid_email_address
    response.should render_template("new")
  end
end