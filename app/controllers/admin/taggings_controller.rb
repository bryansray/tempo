class Admin::TaggingsController < ApplicationController
  def destroy
    @tagging = Tagging.find params[:id]
    @tagging.destroy
  end
end
