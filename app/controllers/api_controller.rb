class ApiController < ApplicationController

  def base
    @site = Site.find_by_auth_hash(params[:h])
    unless @site
      render :nothing => true, :status => 401 and return
    end
  end

end
