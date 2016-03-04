# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

b1 = Brewery.create name:"Koff", year:1897, active:true
b2 = Brewery.create name:"Malmgard", year:2001, active:true
b3 = Brewery.create name:"Weihenstephaner", year:1042, active:true
b4 = Brewery.create name:"Joukon Poltto", year:1995, active:false

be1 = b1.beers.create name:"Iso 3", style:"Lager"
be2 = b1.beers.create name:"Karhu", style:"Lager"
be3 = b1.beers.create name:"Tuplahumala", style:"Lager"
be4 = b2.beers.create name:"Petolintu", style:"Pale Ale"
be5 = b4.beers.create name:"Frankensteiner", style:"Unknown"

u1 = User.create username:"Auto", password:"Sala1", password_confirmation:"Sala1", admin:true
u2 = User.create username:"Koira", password:"Sala1", password_confirmation:"Sala1"
u3 = User.create username:"Jalka", password:"Sala1", password_confirmation:"Sala1", banned:true

u1.ratings.create beer:be1, score:20
u1.ratings.create beer:be2, score:10
u1.ratings.create beer:be3, score:24
u1.ratings.create beer:be8, score:18
u2.ratings.create beer:be1, score:30
u2.ratings.create beer:be4, score:45
u3.ratings.create beer:be5, score:50
