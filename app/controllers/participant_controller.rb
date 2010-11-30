class ParticipantController < ApplicationController
  before_filter :authenticate_user!, :only => :search
  def search
    if params[:term].nil?
      @participants = current_user.participants      
    else
      @participants = current_user.participants.search_by_name(params[:term])
    end
    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

end
