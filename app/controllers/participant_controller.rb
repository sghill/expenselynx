class ParticipantController < ApplicationController
  before_filter :authenticate_user!, :only => :search
  def search
    @participants = Participant.all
  end

end
