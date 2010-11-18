if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end

CarrierWave.configure do |config|
  config.cloud_files_username = 'sghill'
  config.cloud_files_api_key = '288c59ab036da0230eee8b6ad149ca9c'
  config.cloud_files_container = 'expenselynx'
  config.cloud_files_cdn_host = 'http://c0006753.cdn2.cloudfiles.rackspacecloud.com'
end