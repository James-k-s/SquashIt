# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


puts "Clearing existing data..."

TournamentPlayer.delete_all
Tournament.delete_all
User.destroy_all

puts "Cleared existing data!"

puts "Creating default user..."

james = User.create!(first_name: "James", last_name: "Shuttleworth", email: "james@james.com", password: "password", password_confirmation: "password")

jade = User.create!(first_name: "Jade", last_name: "Derche", email: "jade@jade.com", password: "password", password_confirmation: "password")

sian = User.create!(first_name: "Sian", last_name: "Derche", email: "sian@sian.com", password: "password", password_confirmation: "password")

james.save!
jade.save!
sian.save!

puts "Default user created! #{User.all.count} user(s) in the database."

puts "Creating default tournaments..."

Tournament.create!(
  name: "Summer Squash Championship",
  start_date: "2025-06-01 10:00:00",
  end_date: "2025-06-05 18:00:00",
  location: "Downtown Squash Club",
  description: "An exciting tournament for squash enthusiasts of all levels.",
  bracket_type: "Single Elimination",
  max_players: 32,
  min_players: 8,
  created_by_user_id: User.first.id,
  status: "scheduled"
)

Tournament.create!(
  name: "Winter Squash Open",
  start_date: "2025-12-01 10:00:00",
  end_date: "2025-12-05 18:00:00",
  location: "City Sports Center",
  description: "A thrilling competition to close out the year.",
  bracket_type: "Double Elimination",
  max_players: 64,
  min_players: 16,
  created_by_user_id: User.first.id,
  status: "scheduled"
)

puts "#{Tournament.count} tournaments created!"


TournamentPlayer.create!(
  tournament_id: Tournament.first.id,
  user_id: james.id,
  status: "registered"
)

TournamentPlayer.create!(
  tournament_id: Tournament.first.id,
  user_id: jade.id,
  status: "registered"
)

TournamentPlayer.create!(
  tournament_id: Tournament.first.id,
  user_id: sian.id,
  status: "registered"
)
puts "Creating #{TournamentPlayer.count} tournament players..."

puts "Seeding complete!"
