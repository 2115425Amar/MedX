# db/seeds.rb

admin = User.create!(
  email: "doctor@example.com",
  password: "doctor",
  password_confirmation: "doctor",
  phone_number: "1234567899",
  first_name: "Doctor",
  last_name: "Admin",
  active: true # if you use an `active` flag
)

admin.add_role :admin
puts "✅ Admin user created with email: admin@example.com and password: password"
