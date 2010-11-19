require 'spec_helper'
require 'carrierwave/test/matchers'

describe ReceiptImageUploader do
  include CarrierWave::Test::Matchers
  
  HORRIBLE_STATIC_FILE_LOCATION = "/Users/ThoughtWorks/sgdev/expenselynx/spec"

  before do
    @user = Factory(:user)
    @uploader = ReceiptImageUploader.new(@user)
  end

  after do
  end

  context "When saving to a directory" do
    it "should save to receipt folder" do
      @uploader.store_dir.should include("receipts/")
    end
  
    it "should save to user id subfolder" do
      @uploader.store_dir.should include("/#{@user.id}/")
    end
  end
  
  context "When saving a file" do
    it "should allow png" do
      @uploader.store!(File.open("#{HORRIBLE_STATIC_FILE_LOCATION}/tmp/test.png"))
    end
    
    it "should allow jpg" do
      @uploader.store!(File.open("#{HORRIBLE_STATIC_FILE_LOCATION}/tmp/test.jpg"))      
    end
    
    it "should allow jpeg" do
      @uploader.store!(File.open("#{HORRIBLE_STATIC_FILE_LOCATION}/tmp/test.jpeg"))      
    end
    
    it "should allow pdf" do
      @uploader.store!(File.open("#{HORRIBLE_STATIC_FILE_LOCATION}/tmp/test.pdf"))            
    end
  end
end