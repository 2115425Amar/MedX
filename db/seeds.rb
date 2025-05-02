# db/seeds.rb
# db/seeds.rb
doctor = User.create!(
  email: "doctor1234@example.com",
  password: "password",
  first_name: "Doctor",
  last_name: "Two",
  phone_number: "9876543211"
)
doctor.add_role(:doctor)

admin = User.create!(
  email: "amar2115425@akgec.ac.in",
  password: "password",
  first_name: "Receptionist",
  last_name: "Admin",
  phone_number: "9876543555"
)
admin.add_role(:admin)