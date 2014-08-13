# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Splatt.delete_all
User.delete_all

User.create!([
  {id: 1, email: "foo@bar.com", password: "foobar6!", name: "Test User", blurb: "This is a test user"},
  {id: 2, email: "foo@fighters.com", password: "P@ssw0rd", name: "John Doe", blurb: "Splatts by John"},
  {id: 3, email: "address@domain.com", password: "ICantR3member?", name: "Jimmy User", blurb: ""}
])
