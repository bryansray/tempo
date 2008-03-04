class Admin::PasswordsController < ApplicationController
  # Enter email address to recover password
  def new
  end
  
  # POST
  def create
    return unless request.post?
    if @user = User.find_for_forget(params[:email])
      @user.forgot_password
      @user.save
      flash[:notice] = "A password reset email has been sent to the email address"
      redirect_to login_path
    else
      flash[:notice] = "Could not find a user with that email address"
      render :template => "admin/passwords/new"
    end
  end
  
  # RESET password action - /reset_password/:id
  # Checks to make sure that an :id is included and makes sure that the password field isn't blank
  def update
    if  params[:id].nil?
      render :action => 'new'
      return
    end
    
    if params[:password].blank?
      flash[:notice] = "Password field can not be blank."
      render :action => "edit", :id => params[:id]
    end
    
    @user = User.find_by_password_reset_code(params[:id])
  end
end
