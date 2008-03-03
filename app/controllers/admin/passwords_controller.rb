class Admin::PasswordsController < ApplicationController
  # Enter email address to recover password
  def new
  end
  
  def create
    if @user = User.find_for_forget(params[:email])
      @user.forgot_password
      @user.save
      flash[:notice] = "A password reset email has been sent to the email address"
      redirect_to login_path
    else
      flash[:notice] = "Could not find a user with that email address"
      render :template => "new"
    end
  end
end
