json.questions @questions do |question|
  json.id question.id
  json.stem question.stem
  json.answer_1 question.answer_1
  json.answer_2 question.answer_2
  json.answer_3 question.answer_3
  json.answer_4 question.answer_4
  json.answer_5 question.answer_5
  json.correct_answer question.correct_answer
  json.explanation question.explanation
  json.specialty_id question.specialty_id
end
