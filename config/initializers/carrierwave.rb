if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.permissions = 0444
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.storage = :cloud_files
    config.permissions = 0444
    config.cloud_files_username = 'sghill'
    config.cloud_files_api_key = '288c59ab036da0230eee8b6ad149ca9c'
    config.cloud_files_container = 'expenselynx'
    config.cloud_files_cdn_host = 'http://c0006753.cdn2.cloudfiles.rackspacecloud.com'
  end
end