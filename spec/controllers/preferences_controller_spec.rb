require 'spec_helper'

describe PreferencesController do
  include Devise::TestHelpers

  describe :edit do
    it "should be successful" do
      sign_in Factory(:user)
      get :edit
      response.should be_success
    end
  end
end
