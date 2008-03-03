require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AccountsController, "#{}routes_for" do
  it "should map { :controller => 'accounts', :action => 'reset_password' } to /admin/accounts/reset_password" do
    route_for(:controller => "admin/accounts", :action => "reset_password", :id => 1).should == "/reset_password/1"
  end
end

describe Admin::AccountsController, "handling /reset_password/1" do
  before(:each) do
    @user = mock_model(User, :to_param => 1)
    @user.stub!(:find_by_password_reset_code).and_return(@user)
  end
  
  def do_get
    get :reset_password, :id => 1
  end
  
  it "should find the user by the specified reset code" do
    User.should_receive(:find_by_password_reset_code).with("1").and_return(@user)
    do_get
  end
end
