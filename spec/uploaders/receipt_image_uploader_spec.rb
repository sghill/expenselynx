require 'spec_helper'
require 'carrierwave/test/matchers'

describe ReceiptImageUploader do
  include CarrierWave::Test::Matchers

  before do
    @user = Factory(:user)
    @uploader = ReceiptImageUploader.new(@user)
  end

  after do
  end

  it "should save to receipt folder" do
    @uploader.store_dir.should include("receipts/")
  end
  
  it "should save to user id subfolder" do
    @uploader.store_dir.should include("/#{@user.id}/")
  end
end