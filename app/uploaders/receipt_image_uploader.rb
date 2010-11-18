# encoding: utf-8

class ReceiptImageUploader < CarrierWave::Uploader::Base
  storage :cloud_files
  
  def initialize( user )
    @user = user
  end

  def store_dir
    "receipts/#{@user.id}/"
  end
end
