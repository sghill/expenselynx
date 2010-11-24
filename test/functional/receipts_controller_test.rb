require 'test_helper'

class ReceiptsControllerTest < ActionController::TestCase
  setup do
    @chipotle = Factory(:chipotle)
    @john = Factory(:user)
    @sara = Factory(:sara)
    @receipt = Receipt.create(:store => @chipotle, :user => @john, :purchase_date => 2.days.ago, :total => 13.34)
    @today = Time.now.to_date
  end

  test "should not get index if not logged in" do
    get :index
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should get index when logged in" do
    sign_in @john
    get :index
    assert_response :success
    assert_not_nil assigns(:receipts)
  end
  
  test "form in index should have todays date preloaded" do
    sign_in @john
    get :index
    assert_equal @today, assigns(:receipt).purchase_date
  end

  test "should not get new if not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should get new when logged in" do
    sign_in @john
    get :new
    assert_response :success
    assert_not_nil assigns(:receipt)
  end
  
  test "GET new should already have todays date for purchase date" do
    sign_in @john
    get :new
    assert_equal Time.now.to_date, assigns(:receipt).purchase_date
  end
  
  test "should not POST create if not logged in" do
    post :create, :receipt => { :store_name => "Target", :purchase_date => @today, :total => 17.54 }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should POST create receipt with date when logged in" do
    sign_in @john
    assert_difference('Receipt.count') do
      post :create, :receipt => { :store_name => "Target", :purchase_date => @today, :total => 18.46 }
    end

    assert_redirected_to receipt_path(assigns(:receipt))
  end

  test "should not get show receipt if not logged in" do
    get :show, :id => @receipt.to_param
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should get show receipt when logged in" do
    sign_in @john
    post :create, :receipt => { :store_name => "Target",
                                :purchase_date => @today,
                                :total => 19.43 }
    get :show, :id => assigns(:receipt).id
    assert_response :success
  end

  test "should not get edit if not logged in" do
    get :edit, :id => @receipt.to_param
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should get edit when logged in" do
    sign_in @john
    get :edit, :id => @receipt.to_param
    assert_response :success
  end
  
  test "should not update receipt if not signed in" do
    put :update, :id => @receipt.to_param, :receipt => @receipt.attributes
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update receipt when signed in" do
    sign_in @john
    put :update, :id => @receipt.to_param, :receipt => {:store_name => @receipt.store.name,
                                                        :purchase_date => 1.day.ago,
                                                        :total => 8.32}
    assert_redirected_to receipt_path(assigns(:receipt))
  end
  
  test "should not destroy receipt if not signed in" do
    delete :destroy, :id => @receipt.to_param
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should destroy receipt" do
    sign_in @john
    assert_difference('Receipt.count', -1) do
      delete :destroy, :id => @receipt.to_param
    end

    assert_redirected_to receipts_path
  end
  
  #
  #
  #
  test "should show all receipts on index" do
    sign_in @john
    post :create, :receipt => {:store_name => "Target",:purchase_date => @today,:total => 14}
    post :create, :receipt => {:store_name => "Baja Fresh",:purchase_date => 1.day.ago,:total => 15}
    post :create, :receipt => {:store_name => "Chipotle",:purchase_date => 2.days.ago,:total => 11.05}
    post :create, :receipt => {:store_name => "Target",:purchase_date => 3.days.ago,:total => 13.50}
    post :create, :receipt => {:store_name => "Target",:purchase_date => 4.days.ago,:total => 14.00}
    post :create, :receipt => {:store_name => "Chipotle",:purchase_date => 2.days.ago,:total => 17.00}
    
    get :index
    #because there is data in the setup...yikes 
    assert_equal 7, assigns(:receipts).count
  end
  
  test "should show the 5 most recently purchased receipts on index" do
    sign_in @john
    oldest = Receipt.create(:store => @chipotle,:purchase_date => 61.days.ago,:total => 14, :user => @john)
             Receipt.create(:store => @chipotle,:purchase_date => 50.days.ago,:total => 13, :user => @john)
    newest = Receipt.create(:store => @chipotle,:purchase_date => 2.days.ago, :total => 120,:user => @john)
             Receipt.create(:store => @chipotle,:purchase_date => 3.days.ago, :total => 10, :user => @john)
             Receipt.create(:store => @chipotle,:purchase_date => 19.days.ago,:total => 14, :user => @john)
    
    get :index
    assert_equal newest, assigns(:receipts).first
    assert_equal oldest, assigns(:receipts).last
  end
  
  #
  # authorization
  #
  test "should not show a receipt created by another user" do
    sign_in @sara
    post :create, :receipt => { :store_name => "Target", :purchase_date => @today, :total => 17.34 }
    sign_out @sara
    sign_in @john
    
    assert_raise ActiveRecord::RecordNotFound do
      get :show, :id => assigns(:receipt).id
    end
  end
  
  test "should not show receipts created by other users" do
    sign_in @john
    post :create, :receipt => { :store_name => "Target", :purchase_date => @today, :total => 6.50 }
    sign_out @john
    sign_in @sara
    
    get :index
    assert assigns(:receipts).empty?
  end
  
  test "should not load a receipt for editing that belongs to another user" do
    johns_receipt = Receipt.create(:store => @chipotle,:purchase_date => @today,:total => 14,:user => @john)
    
    sign_in @sara
    
    assert_raise ActiveRecord::RecordNotFound do
      get :edit, :id => johns_receipt.id
    end
  end
  
  test "should not put an update for receipt belonging to another user" do
    johns_receipt = Receipt.create(:store => @chipotle,:purchase_date => @today,:total => 14,:user => @john)
    
    sign_in @sara
    
    johns_receipt[:purchase_date] = 1.day.ago
    
    assert_raise ActiveRecord::RecordNotFound do
      put :update, :id => johns_receipt.id, :receipt => johns_receipt
    end
  end
  
  test "should not be able to destroy another users receipt" do
    johns_receipt = Receipt.create(:store => @chipotle,:purchase_date => @today,:total => 14,:user => @john)
    
    sign_in @sara
    
    assert_raise ActiveRecord::RecordNotFound do
      delete :destroy, :id => johns_receipt.id
    end
  end
  
  #
  # image uploading
  #
  HORRIBLE_STATIC_FILE_LOCATION = "/Users/ThoughtWorks/sgdev/expenselynx/spec"
  
  test "should save receipt with png image attachment" do
    sign_in @john
    post :create, :receipt => { :store_name => "Target", 
                                :purchase_date => 1.day.ago, 
                                :total => 6.50,
                                :receipt_image => File.open("#{HORRIBLE_STATIC_FILE_LOCATION}/tmp/test.png") }
    get :show, :id => assigns(:receipt).id
    assert_equal "test.png", assigns(:receipt).receipt_image
  end
  
  test "should save receipt with jpg image attachment" do
    sign_in @john
    post :create, :receipt => { :store_name => "Target", 
                                :purchase_date => 1.day.ago, 
                                :total => 6.50,
                                :receipt_image => File.open("#{HORRIBLE_STATIC_FILE_LOCATION}/tmp/test.jpg") }
    get :show, :id => assigns(:receipt).id
    assert_equal "test.jpg", assigns(:receipt).receipt_image
  end
  
  test "should save receipt with jpeg image attachment" do
    sign_in @john
    post :create, :receipt => { :store_name => "Target", 
                                :purchase_date => 1.day.ago, 
                                :total => 6.50,
                                :receipt_image => File.open("#{HORRIBLE_STATIC_FILE_LOCATION}/tmp/test.jpeg") }
    get :show, :id => assigns(:receipt).id
    assert_equal "test.jpeg", assigns(:receipt).receipt_image
  end
  
  test "should save receipt with pdf image attachment" do
    sign_in @john
    post :create, :receipt => { :store_name => "Target", 
                                :purchase_date => 1.day.ago, 
                                :total => 6.50,
                                :receipt_image => File.open("#{HORRIBLE_STATIC_FILE_LOCATION}/tmp/test.pdf") }
    get :show, :id => assigns(:receipt).id
    assert_equal "test.pdf", assigns(:receipt).receipt_image
  end
  
  test "should not save receipt with bmp image attachment" do
    sign_in @john
    assert_raises CarrierWave::IntegrityError do
      post :create, :receipt => { :store_name => "Target", 
                                  :purchase_date => 1.day.ago, 
                                  :total => 6.50,
                                  :receipt_image => File.open("#{HORRIBLE_STATIC_FILE_LOCATION}/tmp/test.bmp") }
    end
  end
  
  #
  # participants
  #
  test "should add a participant name to a receipt" do
    sign_in @john
    post :create, :receipt => { :store_name => "Target", :purchase_date => 1.day.ago, :total => 18.46 }, 
                  :participant_names => "craig lewis"
    assert_not_nil assigns(:receipt).participants.first
  end
  
  test "should add a comma separated list of participants to a receipt" do
    sign_in @john
    post :create, :receipt => { :store_name => "Target", :purchase_date => 1.day.ago, :total => 18.46 }, 
                  :participant_names => "craig lewis, john henry"
    assert_equal 2, assigns(:receipt).participants.count
  end
  
  test "should add the same participant to different receipts with different casing if spelling is the same" do
    sign_in @john
    post :create, :receipt => { :store_name => "Target", :purchase_date => 1.day.ago, :total => 18.46 }, 
                  :participant_names => "craig lewis, john henry"
    post :create, :receipt => { :store_name => "Starbucks", :purchase_date => 3.days.ago, :total => 218.46 }, 
                  :participant_names => "CRAIG LEWIS"
    # assert_equal 2, Participant.find_by_name("craig lewis").receipts.count
    assert true
  end
end
