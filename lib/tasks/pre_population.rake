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

task :import_notes => :environment do
  puts "Importing notes"
  error_ids = []
  count = 1
  CSV.foreach(File.join(Rails.root, 'lib', 'assets', 'notes.csv'), :headers => true, :encoding => 'ISO-8859-1:UTF-8') do |row|
    puts "Note count is #{count}"

    note = Note.new

    note.created_at = row["created_at"]
    note.updated_at = row["updated_at"]

    # set the user_id
    note.user_id = row["user_id"]

    # set the specialty of the note
    note.specialty_id = row["specialty_id"]

    # set the podcast and type of the note
    if row["video_id"] != nil
      note.noteable_id = row["video_id"]
      note.noteable_type = "Video"
    else
      note.noteable_id = row["specialty_id"]
      note.noteable_type = "Specialty"
    end

    # set the title
    if row["title"].blank?
      note.title = "Untitled"
    else
      note.title = row["title"]
    end

    # set the content
    if row["content"].blank?
      note.content = "No content"
    else
      note.content = row["content"]
    end

    unless note.save
      error_ids << note.errors
    end

    count += 1
  end
  puts "Completed importing notes"
  puts "We found errors with the following ids: #{error_ids}"

end
