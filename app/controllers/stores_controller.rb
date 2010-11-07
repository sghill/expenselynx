class StoresController < ApplicationController
  def search
    if params[:term]
      @stores = Store.search_by_name(params[:term])
    else
      @stores = Store.all
    end
    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
end
