require 'spec_helper'
require 'killer_rspec_rack'

describe '/api/receipts' do
  include KillerRspecRack

  def app
    Expenselynx::Application
  end

  the_response_of '/api/receipts' do
    it { should be_unauthorized }
  end

  context "user is authorised" do
    before :each do
      Factory.create :user, :email => 'user@example.com', :password => 'password'
      authorize "user@example.com", "password"
    end

    the_response_of '/api/receipts' do
      it { should be_ok_and_json }
    end

    the_response_body_of '/api/receipts' do
      it { should have_key("receipts").with_value([]) }
    end
  end
end
