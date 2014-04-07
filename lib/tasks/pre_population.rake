desc "This task is used to prepopulate position of videos within each specialty"

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
