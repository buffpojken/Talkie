class SettingsController < ApplicationController
  
  before_filter :login_required
  
  def index
    
  end
  
  # Update settings for the user, including avatar
  def create
    if @current_user.update_attributes(params[:user])
      flash[:notice] = "Settings update"
    else
      logger.info @current_user.errors.inspect
      flash[:error] = "We could not update the settings right now, try again!"
    end
    redirect_to settings_path and return
  end
  
  def remove
    @current_user.update_attribute(:avatar, nil)
    redirect_to settings_path and return
  end

end
