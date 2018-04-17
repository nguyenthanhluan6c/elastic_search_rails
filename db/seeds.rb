# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.locale = :en
Article.import force: true
Person.import force: true

10000.times do
  Article.create title: Faker::Lorem.sentence, text: Faker::Lorem.paragraph
end

10000.times do
  Person.create first_name: Faker::Name.first_name, last_name: Faker::Name.last_name
end
