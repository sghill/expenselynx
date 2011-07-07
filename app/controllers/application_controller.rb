class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!

  def downloadable filename = params[:action]
    headers["Content-Disposition"] = "attachment; filename=\"#{filename}.#{params[:format]}\""
  end
  
  protected
    def authenticate_admin!
      unless current_user && current_user.admin?
        redirect_to root_path, :notice => 'must be admin to go there'
      end
    end
end
