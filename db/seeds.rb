# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Address.create!(street: 'Berkenwoudestraat 22', city: 'Rotterdam', postcode: '3076 JA', country: 'Netherlands', company_name: 'Simonis')
Address.create!(street: 'Walhallalaan 82', city: 'Rotterdam', postcode: '3072 EX', country: 'Netherlands')
Delivery.create!(
  pickup_address: Address.first,
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
  description: "2x Plasterboards"
)

Company.create(name: 'Simonis', tax_id: '123456789').image.attach(io: File.open('app/assets/images/seed_images/simonis-logo.png'), filename: 'logo_1.jpg')
