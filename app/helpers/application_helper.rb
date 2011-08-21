module ApplicationHelper

  def mark_selected(ctr)
    if params[:controller] == ctr
      'current'
    end  
  end
  
end
