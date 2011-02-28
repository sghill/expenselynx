class ApplicationController < ActionController::Base
  protect_from_forgery

  def downloadable filename = params[:action]
    headers["Content-Disposition"] = "attachment; filename=\"#{filename}.#{params[:format]}\""
  end
end
