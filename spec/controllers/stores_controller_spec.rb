require 'spec_helper'

describe StoresController do
  include Devise::TestHelpers

  context "with users sara and john and store 'Ace Hardware'" do
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

      context "sara is logged in" do
        before :each do
          sign_in @sara
        end
        it "should contain the specified store" do
          get :show, :id => @store.id
          assigns(:store).name.should == @store.name
        end

        it "should show the expense categories for current user and store" do
          ExpenseCategory.should_receive(:for_user_and_store).with(@sara.id, @store.id)
          get :show, :id => @store.id
        end

        it "should show the expense categories for current user and store" do
          categories = [:category, :category]
          ExpenseCategory.stub(:for_user_and_store).and_return(categories)
          get :show, :id => @store.id
          assigns[:expense_categories].should == categories
        end
      end
    end
  end

  context "with stores Chipotle, Baja Fresh, Target and Best Buy existing" do
    let!(:baja) { Factory(:baja_fresh) }
    let!(:best_buy) { Factory(:best_buy) }
    let!(:chipotle) { Factory(:chipotle) }
    let!(:target) { Factory(:target) }

    it "should assign all stores when no search term provided" do
      get :search

      should assign(:stores).with([baja, best_buy, chipotle, target])
    end

    it "should return only stores starting with the search term" do
      get :search, :term => 'b'
      
      should assign(:stores).with([baja, best_buy])
    end
  end
end
