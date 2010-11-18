# encoding: utf-8

class ReceiptImageUploader < CarrierWave::Uploader::Base
  storage :cloud_files

  def store_dir
    'uploads/'
  end
end
