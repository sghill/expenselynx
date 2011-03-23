class ParticipantController < ApplicationController
  before_filter :authenticate_user!, :only => [:search, :index, :merge_zone, :merge]

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
    @participants.reset_column_information
  end

  def merge_zone
    @participants = current_user.participants
  end

  def merge
    service = ParticipantService.new(current_user)
    service.merge(params[:participant_ids].map(&:to_i), params[:participant_name])
    respond_to do |format|
      format.html { redirect_to dashboard_index_path }
    end
  end
end
