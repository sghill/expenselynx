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

    @receipt = Receipt.new(
      :purchase_date => params[:receipt][:purchase_date],
      :total => params[:receipt][:total],
      :store => Store.find_or_create_by_name(params[:receipt][:store_name]),
      :expensable => params[:receipt][:expensable],
      :expensed => params[:receipt][:expensed],
      :note => params[:receipt][:note],
      :user => current_user,
      :participants => participants)

      unless params[:receipt][:receipt_image].nil?
        uploader = ReceiptImageUploader.new(current_user)
        uploader.store!(params[:receipt][:receipt_image])
        @receipt.receipt_image = File.basename(params[:receipt][:receipt_image])
      end

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
      if @receipt.update_attributes(:purchase_date => params[:receipt][:purchase_date],
                                    :total => params[:receipt][:total],
                                    :store => Store.find_or_create_by_name(params[:receipt][:store_name]),
                                    :expensable => params[:receipt][:expensable],
                                    :expensed => params[:receipt][:expensed],
                                    :note => params[:receipt][:note],
                                    :user => current_user,
                                    :participants => participants)
        format.html { redirect_to(@receipt, :notice => 'Receipt was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @receipt = current_user.receipts.find(params[:id])
    @receipt.destroy

    respond_with do |format|
      format.html { redirect_to(receipts_url) }
    end
  end
end
