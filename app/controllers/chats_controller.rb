class ChatsController < ApplicationController

  before_filter :login_required

  # Render all the sites owned by the current user
  def index
    @chats = @current_user.sites
  end

end
