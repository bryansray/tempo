class Admin::AccountsController < ApplicationController
  def change_password
    return unless request.post?
  end
  
  def reset_password
    if params[:id].nil?
      render :action => "new"
      return
    end
    
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @user.nil?
  rescue
    logger.error "Invalid Reset Code entered."
    flash[:notice] = "Sorry - That is an invalid password reset code. Please check your code and try again. (Perhaps your email client inserted a carriage return?)"
  end
  
  def forgot_password
    return unless request.post?
    
    if @user = User.find_by_email(params[:user][:email])
      @user.forgot_password
      @user.save
      Notifier.deliver_forgot_password(@user)
      flash[:notice] = "A password reset link has been sent to your email address"
      
      redirect_back_or_default('/')
    else
      flash[:warning] = "Could not find a user with that email address"
    end
  end
end
