require 'participant_service'

class ReceiptsController < ApplicationController
  before_filter :authenticate_user!, 
    :only => [:index, :new, :create, :show, :edit, :update, :destroy, :upload]
  
  respond_to :html
    
  def index
    @receipt = Receipt.new(:purchase_date => Time.now.to_date)
    @receipts = current_user.receipts.find(:all)
    
    respond_with(@receipt, @receipts)
  end

  def show
    @receipt = current_user.receipts.find(params[:id])
    
    respond_with(@receipt)
  end

  def new
    @receipt = Receipt.new(:purchase_date => Time.now.to_date)
    
    respond_with(@receipt)
  end

  def edit
    @receipt = current_user.receipts.find(params[:id])
  end

  def create
    service = ParticipantService.new(params[:participant_names], current_user)
    participants = service.participants_list
    @receipt = Receipt.new(
      :purchase_date => params[:receipt][:purchase_date],
      :total => params[:receipt][:total],
      :store_id => Store.find_or_create_by_name(params[:receipt][:store_name]).id,
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
        format.js
        format.html { redirect_to(@receipt, :notice => 'Receipt was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @receipt = current_user.receipts.find(params[:id])
     participants = []
      unless params[:old_participants].nil?
        params[:old_participants].each do |guest|
          guy = Participant.find_by_name(guest)
          participants << guy
        end
      end
      unless params[:participant_names].nil?
        params[:participant_names].split(",").each do |name|
          name = name.squeeze(" ").strip
          guy = Participant.find_or_create_by_name(name)
          guy.update_attributes(:user => current_user)
          participants << guy
        end
      end

    respond_to do |format|
      if @receipt.update_attributes(:purchase_date => params[:receipt][:purchase_date],
          :total => params[:receipt][:total],
          :store_id => Store.find_or_create_by_name(params[:receipt][:store_name]).id,
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