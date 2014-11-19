task :update_specialty_id => :environment do
  puts 'Populating specialty_id field in question model'
  Question.all.each do |question|
    question.specialty_id = question.video.specialty_id
    question.save
  end
  puts "Finished populating questions with specialty ids"

end