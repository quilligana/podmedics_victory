# DEV ENV ONLY
# Create sample categories
Category.create([
  { name: 'Medicine'},
  { name: 'Surgery'}
])

# Create sample specialties
Specialty.create([
  { name: 'Cardiology', category_id: 1},
  { name: 'Dermatology', category_id: 1},
  { name: 'Generaly Surgery', category_id: 2},
  { name: 'Vascular', category_id: 2}
])

# Create sample videos
Video.create([
  { title: 'Acute Coronary Syndrome', description: 'test', specialty_id: 1, duration: 10, vimeo_identifier: 123456},
  { title: 'Heart Failure', description: 'test', specialty_id: 1, duration: 10, vimeo_identifier: 123456},
  { title: 'Acne', description: 'test', specialty_id: 2, duration: 10, vimeo_identifier: 123456},
  { title: 'Eczema', description: 'test', specialty_id: 2, duration: 10, vimeo_identifier: 123456},
  { title: 'Appendicities', description: 'test', specialty_id: 3, duration: 10, vimeo_identifier: 123456},
  { title: 'Thyroid Disease', description: 'test', specialty_id: 3, duration: 10, vimeo_identifier: 123456},
  { title: 'Leg Ulcers', description: 'test', specialty_id: 4, duration: 10, vimeo_identifier: 123456}
])

# Create sample questions for video 1
Question.create([
  { stem: 'This is a stem?', answer_1: 'ACE-inhibitor', answer_2: 'Beta-blocker', answer_3: 'Diuretic', answer_4: 'Calcium channel blocker', answer_5: 'Spironolactone', correct_answer: 4, explanation: 'This is an explanation.', video_id: 1 },
  { stem: 'This is a second stem?', answer_1: 'ACE-inhibitor', answer_2: 'Beta-blocker', answer_3: 'Diuretic', answer_4: 'Calcium channel blocker', answer_5: 'Spironolactone', correct_answer: 3, explanation: 'This is an explanation.', video_id: 1 },
  { stem: 'This is a third stem?', answer_1: 'ACE-inhibitor', answer_2: 'Beta-blocker', answer_3: 'Diuretic', answer_4: 'Calcium channel blocker', answer_5: 'Spironolactone', correct_answer: 2, explanation: 'This is an explanation.', video_id: 1 },
  { stem: 'This is a fourth stem?', answer_1: 'ACE-inhibitor', answer_2: 'Beta-blocker', answer_3: 'Diuretic', answer_4: 'Calcium channel blocker', answer_5: 'Spironolactone', correct_answer: 1, explanation: 'This is an explanation.', video_id: 1 },
  { stem: 'This is a heart failure stem?', answer_1: 'ACE-inhibitor', answer_2: 'Beta-blocker', answer_3: 'Diuretic', answer_4: 'Calcium channel blocker', answer_5: 'Spironolactone', correct_answer: 4, explanation: 'This is an explanation.', video_id: 2 },
  { stem: 'This is a second heart failure stem?', answer_1: 'ACE-inhibitor', answer_2: 'Beta-blocker', answer_3: 'Diuretic', answer_4: 'Calcium channel blocker', answer_5: 'Spironolactone', correct_answer: 3, explanation: 'This is an explanation.', video_id: 2 },
  { stem: 'This is a third heart failure stem?', answer_1: 'ACE-inhibitor', answer_2: 'Beta-blocker', answer_3: 'Diuretic', answer_4: 'Calcium channel blocker', answer_5: 'Spironolactone', correct_answer: 2, explanation: 'This is an explanation.', video_id: 2 },
  { stem: 'This is a fourth heart failure stem?', answer_1: 'ACE-inhibitor', answer_2: 'Beta-blocker', answer_3: 'Diuretic', answer_4: 'Calcium channel blocker', answer_5: 'Spironolactone', correct_answer: 1, explanation: 'This is an explanation.', video_id: 2 }
])


# Create a sample admin
User.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true)