# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.create(name: "Books", description: "Literature category")
Category.create(name: "Movies", description: "Cinema category")
Category.create(name: "TV Series", description: "Series category")
Category.create(name: "Comics", description: "The 9th art")