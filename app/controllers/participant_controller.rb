require 'participant_service'

class ParticipantController < ApplicationController
  before_filter :authenticate_user!, :only => [:search, :index, :merge]
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

  def index
    @participants = current_user.participants
  end
  
  def merge
    service = ParticipantService.new(current_user)
    
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end
end
