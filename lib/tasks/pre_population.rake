task :give_positions => :environment do
  puts 'Assigning positions'
  Specialty.all.each do |specialty|
    counter = 1
    specialty.videos.each do |video|
      video.update_attributes(position: counter)
      counter +=1
    end
    "Assigned positions for #{counter} videos in #{specialty.name}"
  end
  puts 'Finished assigning positions'
end

task :import_users => :environment do
  puts 'Importing file and adding users'
  error_ids = []
  CSV.foreach(File.join(Rails.root, 'lib', 'assets', 'users.csv'), :headers => true, :encoding => 'ISO-8859-1:UTF-8') do |row|
    # find by id
    user = User.new
    puts "Adding a new user with id of #{row["id"]}"

    # set the id (we need this for notes)
    user.id = row["id"]

    # set the created at
    user.created_at = row["created_at"]

    # set the name and email
    user.name = row["name"]
    user.email = row["email"]

    # set the subscribed_on (if there is one)
    date = row["subscribed_on"]
    if date != nil
      user.subscribed_on = date
      user.selected_plan = true
    end

    # deal with newsletters
    # if they are false unsub from everything
    if row["receive_newsletter"] == 'false'
      user.receive_newsletters = false
      user.receive_new_episode_notifications = false
    end

    # set a temporary random password
    temp_password = SecureRandom.hex(8)
    user.password = temp_password
    user.password_confirmation = temp_password

    # save the user
    unless user.save
      error_ids << user.id
      puts "User with id of #{user.id} did not save"
    end
  end
  puts "Completed importing users"
  puts "We found errors with the following ids: #{error_ids}"
end
