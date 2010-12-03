require 'spec_helper'

describe StoresController do
  include Devise::TestHelpers
  
  before do
    @sara = Factory(:sara)
    @store = Store.create(:name => 'Moose Jaw')
  end
  
  context "GET edit" do
    it "should require user to log in to see a store for editing" do
      get :edit, :id => @store.to_param
      response.should redirect_to(new_user_session_path)
    end
    
    it "should contain the specified store" do
      sign_in @sara
      get :edit, :id => @store.to_param
      assigns(:store).name.should == @store.name
    end
  end
  
  context "PUT update" do
    it "should not change the store name for a normal user" do
      put :update, :id => @store.to_param, :store => Store.new(:name => 'Coffee Place')
      assigns(:store).name.should_not == "Coffee Place"
    end
  end
end