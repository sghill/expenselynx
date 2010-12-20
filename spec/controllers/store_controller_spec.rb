require 'spec_helper'

describe StoresController do
  include Devise::TestHelpers
  
  before do
    @sara = Factory(:sara)
    @john = Factory(:user)
    @store = Store.create(:name => "Ace Hardware")
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
      sign_in @sara
      put :update, :id => @store.to_param, :store => Store.new(:name => 'Coffee Place')
      assigns(:store).name.should_not == "Coffee Place"
    end
    
    it "should allow the user to assign an expense category" do
      sign_in @sara
      put :update, :id => @store.id, :store => {:name => 'Abc', :expense_categories => "airfare"}
      assigns(:store).expense_categories.should_not be_nil
    end
    
    it "should have different expense categories per store per user" do
      sign_in @sara
      put :update, :id => @store.id, :store => {:name => 'Abc', :expense_categories => "airfare"}
      sign_out @sara
      sign_in @john
      put :update, :id => @store.id, :store => {:name => 'Abc', :expense_categories => "business meals"}
      
      get :show, :id => @store.id
      assigns(:expense_categories).length.should == 1
      assigns(:expense_categories).first.name.should == "business meals"
    end
  end
  
  context "GET show" do
    it "should require login" do
      get :show, :id => @store.id
      response.should redirect_to(new_user_session_path)
    end
    
    it "should contain the specified store" do
      sign_in @sara
      get :show, :id => @store.id
      assigns(:store).name.should == @store.name
    end
  end
end