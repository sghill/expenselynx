class ReceiptsController < ApplicationController
  before_filter :authenticate_user!, 
    :only => [:index, :new, :create, :show, :edit, :update, :destroy]
    
  def index
    @receipt = Receipt.new
    @receipts = Receipt.find(:all, :limit => 5)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @receipts }
    end
  end

  def show
    @receipt = current_user.receipts.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @receipt }
    end
  end

  def new
    @receipt = Receipt.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @receipt }
    end
  end

  def edit
    @receipt = Receipt.find(params[:id])
  end

  def create
    @receipt = Receipt.new(
      :purchase_date => (Date.strptime(params[:receipt][:purchase_date], '%m/%d/%Y')),
      :total => params[:receipt][:total],
      :store_id => Store.find_or_create_by_name(params[:receipt][:store_name]).id,
      :expensable => params[:receipt][:expensable],
      :user => current_user)

    respond_to do |format|
      if @receipt.save
        # ugly hack; for whatever reason adding store_name makes it work...
        format.js  { @receipt['store_name'] = nil; render :json => @receipt }
        format.html { redirect_to(@receipt, :notice => 'Receipt was successfully created.') }
        format.xml  { render :xml => @receipt, :status => :created, :location => @receipt }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @receipt.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @receipt = Receipt.find(params[:id])

    respond_to do |format|
      if @receipt.update_attributes(params[:receipt])
        format.html { redirect_to(@receipt, :notice => 'Receipt was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @receipt.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.destroy

    respond_to do |format|
      format.html { redirect_to(receipts_url) }
      format.xml  { head :ok }
    end
  end
end
