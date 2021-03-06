require 'spec_helper'

describe ExpenseCategoriesController do
  include Devise::TestHelpers

  describe :edit do
    it "should fail without admin signed in" do
      category = ExpenseCategory.create(:name => 'category1')
      sign_in Factory(:user)
      get :edit, :id => category.to_param
      response.should be_redirect
    end
    
    it "should require admin" do
      category = ExpenseCategory.create(:name => 'category1')
      user = Factory(:user, :admin => true)
      sign_in user
      get :edit, :id => category.to_param
      response.should be_success
    end
  end

  describe :index do
    it "should not require admin" do
      sign_in Factory(:user)
      get :index
      response.should be_success
    end
  end
  
  describe :show do
    it "should not require admin" do
      category = ExpenseCategory.create(:name => 'category1')
      sign_in Factory(:user)
      get :show, :id => category.to_param
      response.should be_success
    end
  end
end
