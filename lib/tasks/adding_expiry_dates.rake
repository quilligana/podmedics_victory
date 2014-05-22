task :update_expiry_dates => :environment do
  puts 'Updating expiry date attribute on all subsribed users'
  User.all.each do |user|
    if user.subscribed_on
      puts "Update user with email #{user.email} and subscription date #{user.subscribed_on.to_s(:long)}"
      user.expires_on = (user.subscribed_on + 1.year)
      user.save
    end
  end
  puts "Finished updating user expiry dates"

end
