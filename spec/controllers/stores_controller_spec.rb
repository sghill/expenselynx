require 'spec_helper'

describe StoresController do
  include Devise::TestHelpers
  
  before :all do
    User.delete_all
    Store.delete_all
  end

  let!(:toad) { User.create(email: "toad@example.com", password: "security123") }
  let!(:shaw) { User.create(email: "shaw@example.com", password: "blahdeblah3") }
  let!(:hardware) { Store.create(name: "Family Hardware") }
  let!(:grocery) { Store.create(name: "Grocery Store") }
  let!(:gift_shop) { Store.create(name: "Gift Shop") }

  describe :edit do
    it "should load right store" do
      sign_in toad
      get :edit, id: hardware.to_param
      assigns(:store).name.should == hardware.name
    end
  end
  
  describe :update do
    it "should not allow a user to change the name" do
      sign_in toad
      put :update, id: hardware.to_param, store: { name: "Big Box Hardware" }
      assigns(:store).name.should == hardware.name
    end
  
    it "should allow a user to assign an expense category" do
      expected_category = "airfare"
      sign_in toad
      put :update, id: hardware.to_param, store: { name: hardware.name, expense_categories: expected_category }
      
      actual_category = assigns(:store).expense_categories.first.name
      
      actual_category.should == expected_category
    end
    
    it "should allow different expense categories per store for each user" do
      shaws_category = "business meals"
      
      sign_in toad
      put :update, id: hardware.to_param, store: { name: hardware.name, expense_categories: "airfare" }
      sign_out toad
      
      sign_in shaw
      put :update, id: hardware.to_param, store: { name: hardware.name, expense_categories: shaws_category }
      get :show, id: hardware.to_param
      
      assigns(:expense_categories).length.should == 1
      assigns(:expense_categories).first.name.should == shaws_category
    end
    
  end

  describe :show do
    it "should load the right store" do
      sign_in toad
      get :show, id: hardware.to_param
      assigns(:store).name.should == hardware.name
    end
    
    it "should receive the expense categories for current user and store" do
      sign_in toad
      ExpenseCategory.should_receive(:for_user_and_store).with(toad.id, hardware.to_param)
      get :show, id: hardware.to_param
    end
    
    it "should show the expense categories for current user and store" do
      categories = ["airfare", "business meals"]
      sign_in toad
      ExpenseCategory.stub(:for_user_and_store).and_return(categories)
      get :show, id: hardware.to_param
      should assign(:expense_categories).with(categories)
    end
    
  end

  describe :search do
    it "should assign all stores when no search term provided" do
      get :search
      should assign(:stores).with([hardware, grocery, gift_shop])
    end
    
    it "should return only stores starting with the search term" do
      get :search, term: "g"
      should assign(:stores).with([grocery, gift_shop])
    end
  end
end