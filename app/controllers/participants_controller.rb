class ParticipantsController < ApplicationController

  respond_to :html
  
  def search
    if params[:term].nil?
      @participants = current_user.participants
    else
      @participants = current_user.participants.search_by_name(params[:term])
    end

    respond_with do |format|
      format.html { render :layout => false }
    end
  end

  def index
    @participants = current_user.participants
    @participants.reset_column_information
  end

  def merge_zone
    @participants = current_user.participants
  end

  def merge
    service = ParticipantService.new(current_user)
    service.merge(params[:participant_ids].map(&:to_i), params[:participant_name])
    respond_with do |format|
      format.html { redirect_to dashboard_index_path }
    end
  end
  
  def edit
    @participant = current_user.participants.find(params[:id])
  end
  
  def update
    @participant = current_user.participants.find(params[:id])
    @participant.update_attributes(params[:participant].merge(:user => current_user))
    respond_with @participant
  end
  
  def show
    @participant = current_user.participants.find(params[:id])
  end
end
