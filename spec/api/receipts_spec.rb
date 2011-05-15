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
      @user = Factory.create :user, :email => 'user@example.com', :password => 'password'
      authorize "user@example.com", "password"
    end

    the_response_of '/api/receipts' do
      it { should be_ok_and_json }
    end

    the_response_body_of '/api/receipts' do
      its(["receipts"]) { should == [] }
    end

    context "user has 1 receipt" do
      let!(:burrito) { Factory.create :chipotle_burrito, :user => @user, :total => '27.00' }

      the_response_body_of '/api/receipts' do
        its(["receipts"]) do
          should == [
              {
                  "href" => "http://example.org/api/receipts/#{burrito.id}",
                  "total" => "$27.00",
                  "vendor" => "Chipotle"
              }
          ]
        end
      end
    end
  end
end
