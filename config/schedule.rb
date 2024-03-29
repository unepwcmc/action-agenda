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

set :chronic_options, hours24: true

every 1.day, at: '1:00' do
  runner "CbdImportJob.perform_later"
end

every 2.weeks, at: '1:30' do
  runner "FermImportJob.perform_later"
end

every 1.day, at: '2:00 am' do
  rake 'active_storage:purge_unattached'
end
