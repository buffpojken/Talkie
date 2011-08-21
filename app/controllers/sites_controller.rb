class SitesController < ApplicationController
  
  before_filter :login_required
  
  def index
    @sites  = @current_user.sites.all
  end
  
  def create
    site    = @current_user.sites.create(params[:site]) 
    if site && site.errors.empty? 
      redirect_to setup_site_path(site) and return
    else
      redirect_to :back and return
    end
  end

  def setup
    @site   = @current_user.sites.find(params[:id])
  end
  
  def remove
    site = @current_user.sites.find(params[:id])
    if site && site.destroy
      flash[:notice] = "Site removed"
    else
      flash[:error] = "Couldn't remove site"
    end
    redirect_to :back and return
  end

end
