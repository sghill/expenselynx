class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!

  def downloadable filename = params[:action]
    headers["Content-Disposition"] = "attachment; filename=\"#{filename}.#{params[:format]}\""
  end
end
