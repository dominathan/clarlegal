source 'https://rubygems.org'

ruby '2.0.0'

#==INITALLY ON RAILS NEW==#
gem 'rails', '4.0.3'
gem 'pg'
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

gem 'figaro'
gem 'faker', '1.1.2' #for database population
gem 'highcharts-rails', '~> 4.0.1' #for highcharts.js
gem 'will_paginate' #added to have clickiable page numbers at bottom of page
gem 'will_paginate-bootstrap'
gem 'cocoon'  #nested forms, javascript adds new form

group :development, :test do
  gem 'rspec-rails', '2.13.1'
  gem 'railroady'
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
gem 'bootstrap-sass', '2.3.2.0'
gem 'sprockets', '2.11.0'

#for password validation
gem 'bcrypt-ruby', '3.1.2'

#for easy database viewing
gem 'hirb'

