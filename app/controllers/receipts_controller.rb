class ReceiptsController < ApplicationController
  # GET /receipts
  # GET /receipts.xml
  def index
    @receipt = Receipt.new
    @receipts = Receipt.find(:all, :limit => 5)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @receipts }
    end
  end

  # GET /receipts/1
  # GET /receipts/1.xml
  def show
    @receipt = Receipt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @receipt }
    end
  end

  # GET /receipts/new
  # GET /receipts/new.xml
  def new
    @receipt = Receipt.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @receipt }
    end
  end

  # GET /receipts/1/edit
  def edit
    @receipt = Receipt.find(params[:id])
  end

  # POST /receipts
  # POST /receipts.xml
  def create
    @receipt = Receipt.new(
      :purchase_date => (Date.strptime(params[:receipt][:purchase_date], '%m/%d/%Y')),
      :total => params[:receipt][:total],
      :store_id => Store.find_or_create_by_name(params[:receipt][:store_name]).id)

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

  # PUT /receipts/1
  # PUT /receipts/1.xml
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

  # DELETE /receipts/1
  # DELETE /receipts/1.xml
  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.destroy

    respond_to do |format|
      format.html { redirect_to(receipts_url) }
      format.xml  { head :ok }
    end
  end
end
