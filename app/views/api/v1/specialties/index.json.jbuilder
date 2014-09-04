json.array! @specialties do |specialty|
  json.id specialty.id
  json.name specialty.name
  json.updated_at specialty.updated_at
  json.question_count specialty.questions.count
end
