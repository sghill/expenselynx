require 'participant_service'

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
    service.merge(to_integer_collection(params[:participant_ids]), params[:participant_name])
    respond_to do |format|
      format.html { redirect_to dashboard_index_path }
    end
  end
  
  private
    def to_integer_collection( collection )
      list = []
      collection.each do |c|
        list << c.to_i
      end
      return list
    end
end
