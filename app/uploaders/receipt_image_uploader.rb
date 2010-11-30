# encoding: utf-8

class ReceiptImageUploader < CarrierWave::Uploader::Base
  def initialize( user )
    @user = user
  end
  
  def extension_white_list
    %(png jpg jpeg pdf)
  end

  def store_dir
    "receipts/#{@user.id}/"
  end
end
