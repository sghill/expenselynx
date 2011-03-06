class ReceiptsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html

  def index
    @receipt = Receipt.default
    @receipts = current_user.receipts.find(:all)
  end

  def show
    @receipt = current_user.receipts.find(params[:id])
  end

  def new
    @receipt = Receipt.default
  end

  def edit
    @receipt = current_user.receipts.find(params[:id])
  end

  def create
    service = ParticipantService.new(current_user)
    participants = service.participants_list(params[:participant_names])
    participants.concat(service.participants_list_from_collection(params[:old_participants])) unless params[:old_participants].nil?

    @receipt = Receipt.new(params[:receipt].merge(:user => current_user, :participants => participants))

    respond_to do |format|
      if @receipt.save
        format.js { render :layout => false }
        format.html { redirect_to(@receipt, :notice => 'Receipt was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @receipt = current_user.receipts.find(params[:id])
      service = ParticipantService.new(current_user)
      participants = service.participants_list(params[:participant_names])
      participants.concat service.participants_list_from_collection(params[:old_participants]) unless params[:old_participants].nil?
      
    respond_to do |format|
      if @receipt.update_attributes(params[:receipt].merge(:user => current_user, :participants => participants))
        format.html { redirect_to(@receipt, :notice => 'Receipt was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @receipt = current_user.receipts.find(params[:id])
    @receipt.destroy

    respond_with(@receipt)
  end
end
