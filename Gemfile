source 'https://rubygems.org'

ruby '2.0.0'

#==INITALLY ON RAILS NEW==#
gem 'rails', '4.0.3'
gem 'pg', '0.17.1'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails', '~> 3.0.4'
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
#==EVERYTHING ELSE IS ADDED==#

gem 'figaro', '0.7.0' #application.yml file for safety
gem 'highcharts-rails', '~> 4.0.1' #for highcharts.js
gem 'will_paginate', '3.0.7' #added to have clickiable page numbers at bottom of page
gem 'will_paginate-bootstrap', '1.0.1'
gem 'cocoon', '1.2.6'  #nested forms, javascript adds new form
gem 'whenever', '0.9.2', :require => false #handles cron tasks

group :development, :test do
  gem 'thin', '1.6.3' #local server
  gem 'rspec-rails', '2.13.1'
  gem 'railroady' #road map of
  gem 'pry' #debugging
  gem 'jazz_hands' #easy railsconsole viewing
  gem 'hirb', '0.7.2' #easy railsconsole viewing
  gem 'quiet_assets', '1.0.3' #removes all that logger shit about assets
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0' #simulate client browser experience
  gem 'factory_girl_rails', '4.2.1'  #added for testing
end

group :production do
  gem 'rails_12factor', '0.0.2'
  gem 'passenger', '4.0.53' #production server
end

#for styling
gem 'bootstrap-sass', '3.1.1'
gem 'sprockets', '2.11.0'

gem 'timecop', '0.7.1' #remote time travel
gem 'faker', '1.1.2' #for database population

#for password validation
gem 'bcrypt-ruby', '3.1.2'

#for searching
gem 'mysql2', '0.3.16'
gem 'thinking-sphinx', '3.1.1'
gem 'flying-sphinx', '1.2.0'

#to replace flying-sphinx
gem 'jquery-datatables-rails', '2.2.3'
gem 'jquery-ui-rails', '5.0.3'

gem 'letter_opener', '1.2.0', :group => :development #test email being sent

#actual email being sent
gem 'mandrill_mailer', '0.4.6'
gem 'mandrill-api', '1.0.52'



