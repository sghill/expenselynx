source 'http://rubygems.org'

gem 'rails', '3.0.19'
gem 'devise', '1.4.2'
gem 'slim', '0.9.4'
gem 'decent_exposure', '1.0.1'
gem 'representative', '0.3.6'
gem 'representative_view', '1.1.0'
gem 'money', '3.7.1'

group :production do
  gem 'thin', '1.2.11'
  gem 'pg', '0.11.0'
end

# freezing gems just used in testing to reduce moving parts
group :development, :test do
  gem 'killer_rspec_rack', '0.0.2.trunk', git: 'git://github.com/akiellor/killer_rspec_rack.git'
  
  gem 'timecop', '0.3.5'
  gem 'factory_girl_rails', '1.0.1'
  gem 'rspec-rails', '2.5'
  gem 'rspec', '2.5'
  gem 'rspec-core', '2.5.1'
  gem 'rspec-expectations', '2.5'
  gem 'rspec-mocks', '2.5'
  gem 'capybara', '1.0.0'
  gem 'database_cleaner', '0.6.6'
# TODO: figure out why cucumber blows up since bumping to rails 3.0.19 from 3.0.9
#  gem 'cucumber-rails', '1.0.2'
#  gem 'cucumber', '1.0.0'
  gem 'spork', '0.8.4'
  gem 'launchy', '0.4.0'
  gem 'sqlite3-ruby', '1.3.3', :require => 'sqlite3'
end
