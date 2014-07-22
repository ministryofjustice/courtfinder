# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Parking.create(location_and_cost:'inside-free')
Parking.create(location_and_cost: 'inside-paid')
Parking.create(location_and_cost: 'outside-free')
Parking.create(location_and_cost: 'outside-paid')


