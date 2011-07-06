class Api::ReceiptsController < ApplicationController

  respond_to :json, :xml

  expose(:receipts) do
    current_user.receipts
  end

  expose(:receipt) do
    current_user.receipts.find(params[:id])
  end

  expose(:form) do
    Api::Forms::CreateReceiptForm.new
  end

  def index
    respond_with receipts
  end

  def show
    respond_with receipt
  end

  def create
    form.fill_in(request, current_user).receipt.save!
  end
end
