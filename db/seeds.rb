# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Parking.create(location_and_cost: 'parking_onsite_free')
Parking.create(location_and_cost: 'parking_onsite_paid')
Parking.create(location_and_cost: 'parking_onsite_none')

Parking.create(location_and_cost: 'parking_offsite_free')
Parking.create(location_and_cost: 'parking_offsite_paid')
Parking.create(location_and_cost: 'parking_offsite_none')


