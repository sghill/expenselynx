class ParticipantController < ApplicationController
  before_filter :authenticate_user!, :only => :search
  def search
    @participants = current_user.participants      
    @participants = @participants.search_by_name(params[:term]) unless params[:term].nil?
    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

end
