# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

company = Company.find_or_create_by(name: 'Simonis', tax_id: '123456789')
company.image.attach(io: File.open('app/assets/images/seed_images/simonis-logo.png'), filename: 'logo_1.jpg')
team = Team.find_or_create_by(company_id: Company.first.id)

Address.create!(street: 'Berkenwoudestraat 22', city: 'Rotterdam', postcode: '3076 JA', country: 'Netherlands', company_name: 'Simonis', team_id: team.id)
Address.create!(street: 'Walhallalaan 82', city: 'Rotterdam', postcode: '3072 EX', country: 'Netherlands')
normal_user = User.find_or_create_by!(email: 'testuser@email.com') do |user|
  user.password = 'password'
  user.first_name = 'Test'
  user.last_name = 'User'
  user.sms_opt_in = true
  user.role = 'normal'
  user.time_zone = 'Europe/Amsterdam'
  user.team_id = team.id
  user.company_id = company.id
  user.phone_number = '0612345678'
end

team_admin_user = User.find_or_create_by!(email: 'teamadmin@email.com') do |user|
  user.password = 'password'
  user.first_name = 'Team'
  user.last_name = 'Admin'
  user.sms_opt_in = true
  user.role = 'team_admin'
  user.time_zone = 'Europe/Amsterdam'
  user.team_id = team.id
  user.company_id = company.id
  user.phone_number = '0612345678'
end

company_admin_user = User.find_or_create_by!(email: 'companyadmin@email.com') do |user|
  user.password = 'password'
  user.first_name = 'Company'
  user.last_name = 'Admin'
  user.sms_opt_in = true
  user.role = 'company_admin'
  user.time_zone = 'Europe/Amsterdam'
  user.team_id = team.id
  user.company_id = company.id
  user.phone_number = '0612345678'
end

admin = User.find_or_create_by!(email: 'admin@foremoresupplies.com') do |user|
  user.password = 'password'
  user.first_name = 'Admin'
  user.last_name = 'Foremore'
  user.sms_opt_in = true
  user.role = 'admin'
  user.time_zone = 'Europe/Amsterdam'
  user.phone_number = '0612345678'
end
admin.save

Delivery.create!(
  pickup_address: team.address,
  delivery_address: Address.last.one_line,
  delivery_type: 'instant',
  weight_class: '< 15',
  length_class: '2.2 - 3.4',
  status: 'pending',
  order_reference: "234567",
  other_notes: "Here are some other notes",
  address_notes: "Leave at the door",
  recipient_name: "John Doe",
  recipient_email: "johndoe@email.com",
  recipient_phone: "07842551878",
  scheduled_date: DateTime.now,
  description: "2x Plasterboards",
  user_id: normal_user.id
)

