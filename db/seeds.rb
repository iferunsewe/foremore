# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Address.create!(street: 'Berkenwoudestraat 22', city: 'Rotterdam', postcode: '3076 JA', country: 'Netherlands', company_name: 'Simonis')
Address.create!(street: 'Walhallalaan 82', city: 'Rotterdam', postcode: '3072 EX', country: 'Netherlands')
