class ReceiptsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html

  def index
    respond_with(@receipts = current_user.receipts.find(:all))
  end

  def show
    respond_with(@receipt = current_user.receipts.find(params[:id]))
  end

  def new
    respond_with(@receipt = Receipt.default)
  end

  def edit
    respond_with(@receipt = current_user.receipts.find(params[:id]))
  end

  def create
    #TODO: shove this participant service into the participant model
    service = ParticipantService.new(current_user)
    participants = service.participants_list(params[:participant_names])
    participants.concat(service.participants_list_from_collection(params[:old_participants])) unless params[:old_participants].nil?

    @receipt = Receipt.new(params[:receipt].merge(:user => current_user, :participants => participants))
    @receipt.save
    respond_with(@receipt)
  end

  def update
    @receipt = current_user.receipts.find(params[:id])
    service = ParticipantService.new(current_user)
    participants = service.participants_list(params[:participant_names])
    participants.concat service.participants_list_from_collection(params[:old_participants]) unless params[:old_participants].nil?
    
    @receipt.update_attributes(params[:receipt].merge(:user => current_user, :participants => participants))
    respond_with(@receipt)
  end

  def destroy
    @receipt = current_user.receipts.find(params[:id])
    @receipt.destroy

    respond_with(@receipt)
  end
end
