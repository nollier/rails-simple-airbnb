# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Delete every data'
Flat.destroy_all

puts 'Creating data'
20.times do
  restaurant = Flat.new(
    name: Faker::Movies::StarWars.character,
    address: Faker::Address.full_address,
    description: Faker::String.random,
    price_per_night: Faker::Number.number(digits: 3),
    number_of_guests: Faker::Number.digit
  )
  restaurant.save!
end
puts 'Done'
