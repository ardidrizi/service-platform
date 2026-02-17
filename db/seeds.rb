puts "Clearing existing bookings, services, and users..."
Booking.destroy_all
Service.destroy_all
User.destroy_all

puts "Creating admin and regular users..."
admin = User.create!(email: "admin@example.com", password: "password", role: :admin)
user1 = User.create!(email: "user1@example.com", password: "password", role: :user)
user2 = User.create!(email: "user2@example.com", password: "password", role: :user)

puts "Creating services for user1..."
services = []
services << Service.create!(
  title: "Premium Consultation",
  description: "One-hour deep-dive to answer business or service related questions.",
  price: 120.0,
  user: user1
)
services << Service.create!(
  title: "Standard Consultation",
  description: "Thirty-minute follow-up for ongoing customers.",
  price: 80.0,
  user: user1
)

puts "Creating services for user2..."
services << Service.create!(
  title: "Executive Coaching",
  description: "Guided program that supports executive-level decision making.",
  price: 200.0,
  user: user2
)
services << Service.create!(
  title: "Support Session",
  description: "Two-hour hands-on support to connect systems or onboard teams.",
  price: 150.0,
  user: user2
)

puts "Creating reciprocal bookings between user1 and user2..."
Booking.create!(user: user1, service: services.find { |s| s.user == user2 })
Booking.create!(user: user2, service: services.find { |s| s.user == user1 })

puts "Users: #{User.count}, Services: #{Service.count}, Bookings: #{Booking.count}"
