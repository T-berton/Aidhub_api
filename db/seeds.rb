# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Initialize starting latitude and longitude (Paris coordinates)
starting_latitude = 48.8588376
starting_longitude = 2.2775176

Request.delete_all
User.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('users')


# Create 20 users with ids from 1 to 20
user_data = (1..20).map do |i|
  {first_name: "User", last_name: "#{i}", email: "test#{i}@test.com", password: "test1234" }
end

user_data.each do |data|
  User.create!(data)
end

# Create requests with incrementally distant latitude and longitude
request_data = (1..20).map do |i|
  {
    user_id: i,
    title: "Request #{i+1}",
    task_type: ["One-time Need", "Material Need"].sample,
    description: "This is a description for request #{i+1}",
    latitude: starting_latitude + i * 0.02,
    longitude: starting_longitude + i * 0.02
  }
end


request_data.each do |data|
  Request.create!(data)
end

Request.create!( {user_id: 2, title: "Need help with groceries", task_type: "One-time Need", description: "I need someone to help me with groceries", latitude: 48.8588376, longitude: 3.2775176,user_counter:4 })
