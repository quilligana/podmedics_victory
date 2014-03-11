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

# Create sampe videos
Video.create([
  { title: 'Acute Coronary Syndrome', description: 'test', specialty_id: 1, duration: 10, vimeo_identifier: 123456},
  { title: 'Heart Failure', description: 'test', specialty_id: 1, duration: 10, vimeo_identifier: 123456},
  { title: 'Acne', description: 'test', specialty_id: 2, duration: 10, vimeo_identifier: 123456},
  { title: 'Eczema', description: 'test', specialty_id: 2, duration: 10, vimeo_identifier: 123456},
  { title: 'Appendicities', description: 'test', specialty_id: 3, duration: 10, vimeo_identifier: 123456},
  { title: 'Thyroid Disease', description: 'test', specialty_id: 3, duration: 10, vimeo_identifier: 123456},
  { title: 'Leg Ulcers', description: 'test', specialty_id: 4, duration: 10, vimeo_identifier: 123456}
])


# Create a sample admin
User.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true)

