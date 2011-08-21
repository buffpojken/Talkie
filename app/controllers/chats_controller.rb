class ChatsController < ApplicationController

  before_filter :login_required

  def index
    @chats = @current_user.sites
  end

end
