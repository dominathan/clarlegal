#look at http://asciicasts.com/episodes/164-cron-in-ruby or http://railscasts.com/episodes/164-cron-in-ruby-revised?autoplay=true
#this tells what to do with Capistrano when deployed to own cloud server
#also check bundle exec whenever --update-crontab  if you make changes
set :output, {:error => "#{path}/log/cron_error_log.log", :standard => "#{path}/log/cron_log.log"}


every 1.month do
  runner 'FixedFee.monthly_fixed_fee_adjustment'
  runner 'print "FixedFee Adjustment Ran"'
end

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end



# Learn more: http://github.com/javan/whenever
