# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Claregal::Application.initialize!
# if Rails.env.production?
#   Delayed::Worker.new.start
# end
