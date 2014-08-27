source 'https://rubygems.org'

ruby '2.0.0'

#==INITALLY ON RAILS NEW==#
gem 'rails', '4.0.3'
gem 'pg', '0.17.1'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
#==EVERYTHING ELSE IS ADDED==#

gem 'figaro', '0.7.0' #application.yml file for safety
gem 'faker', '1.1.2' #for database population
gem 'highcharts-rails', '~> 4.0.1' #for highcharts.js
gem 'will_paginate', '3.0.7' #added to have clickiable page numbers at bottom of page
gem 'will_paginate-bootstrap', '1.0.1'
gem 'cocoon', '1.2.6'  #nested forms, javascript adds new form
gem 'whenever', '0.9.2', :require => false
gem 'timecop', '0.7.1' #remote time travel

group :development, :test do
  gem 'rspec-rails', '2.13.1'
  gem 'railroady'
  gem 'pry'
  gem 'jazz_hands'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.1'  #added for testing
end

group :production do
  gem 'rails_12factor', '0.0.2'
end

#for styling
gem 'bootstrap-sass', '3.1.1'
gem 'sprockets', '2.11.0'

#for password validation
gem 'bcrypt-ruby', '3.1.2'

#for easy database viewing
gem 'hirb', '0.7.2'

#for searching
gem 'mysql2', '0.3.16'
gem 'thinking-sphinx', '3.1.1'
gem 'flying-sphinx', '1.2.0'

#test email being sent
gem 'letter_opener', '1.2.0', :group => :development
#actual email being sent
gem 'mandrill_mailer', '0.4.6'
gem 'mandrill-api', '1.0.52'


