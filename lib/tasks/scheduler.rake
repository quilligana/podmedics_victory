desc "Send one week reminder to users who signed up but did not subscribe"
task :one_week_reminders => :environment do
  puts 'sending one week reminders...'
  User.send_one_week_reminders
  puts 'completed sending one week reminders'
end
