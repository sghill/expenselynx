class PreferencesController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :html
  
  def edit
    respond_with(@preferences = current_user.preferences)
  end

  def update
    @preferences = current_user.preferences
    @preferences.update_attributes params[:preferences]
    respond_with @preferences do |format|
      format.html { redirect_to preferences_path, :notice => 'successfully saved preferences' }
    end
  end
end
