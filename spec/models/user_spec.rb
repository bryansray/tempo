require File.dirname(__FILE__) + '/../spec_helper'

describe User do

end

describe User, "with fixtures loaded" do
  fixtures :users, :blogs, :pages, :visits, :contents, :members, :teams
	
  before(:each) do
    @user = users(:one) #User.new
  end

  it "should be valid" do
    @user.should be_valid
  end
  
  it "should have visited pieces of content" do
    @user.should have(2).visits
  end
  
  it "should own pieces of published content" do
    #@user.contents.should have(4).published
  end

  it "should have a blogs assigned to them" do
    @user.should have(2).blogs
  end

  it "should not be valid if login is nil" do
    @user.login = nil
    
    @user.should_not be_valid
  end
  
  it "should not be valid if first_name is nil" do
    @user.first_name = nil
    
    @user.should_not be_valid
  end
  
  it "should not be valid if email address is nil" do
    @user.email = nil
    
    @user.should_not be_valid
  end
  
  it "should not be valid if an password is not entered" do
    @user.password = "321"
    @user.password_confirmation = "123"
    
    @user.should_not be_valid
  end

  it "should not be valid if password and password_confirmation do not match" do
    @user.password = "123"
    @user.password_confirmation = "321"
    
    @user.should_not be_valid
  end
  
  it "should set the recently_forgot_password? method to true after calling forgot_method" do
    @user.forgot_password
    @user.recently_forgot_password?.should be_true
  end


  it "should authenticate the user" do
    @user.should == User.authenticate('Bryan.Ray', 'test')
  end
  
  it "should not authenticate the user on an invalid password" do
    @user.should_not == User.authenticate("Bryan.Ray", "testing")
  end
  
  it "should return to_s in a 'FirstName LastName' format" do
    @user.to_s.should == "Bryan Ray"
  end
  
  it "should not be valid with a login of more than 40 characters" do
  	@user.login = "abcde"*9
  	
  	@user.should_not be_valid
  end
  
  it "should not be valid with an email address over 100" do
  	@user.email = "1234567890"*11
  	
  	@user.should_not be_valid
  end
  
  it "should not allow users to have the same email address" do
  	newUser = users(:two)
  	
  	newUser.email = "bryan.ray@datacert.com"
  	
  	newUser.save.should_not be_true
 end

  it "should own one published wiki page" do
    @user.should have(1).published_pages
  end

  it "should belong to multiple teams" do
    @user.should have(2).teams
  end
  
  it "should show team member history" do
    @user.team_history.should_not be_nil
 end
 
  it "should find the specified user with User.find_for_forget" do
    user = User.find_for_forget("bryan.ray@datacert.com")
    user.should == @user
  end
  
  it "should have a reset password method that clears out the password_reset_code field" do
    @user.reset_password
    @user.password_reset_code.should be_nil
  end
  
  it "should belong to multiple projects" do
    @user.should have(2).projects
  end
  
  it "should set the @reset_password instance variable to true so that an email can be sent out if needed"
end
