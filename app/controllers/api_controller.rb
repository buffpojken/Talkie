##### Author: Daniel Sundström  #####
##### Date: August 21, 2011 - Aug:08:50#####
##### License: MIT License    #####
class ApiController < ApplicationController

  # Render the javascript-base client, splicing in the relevant keys from the site-object 
  def base
    @site = Site.find_by_auth_hash(params[:h])
    unless @site
      render :nothing => true, :status => 401 and return
    end
  end

end
