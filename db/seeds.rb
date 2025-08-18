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

Round.delete_all
Match.delete_all
Invite.delete_all         # add this
Announcement.delete_all
TournamentPlayer.delete_all
Tournament.delete_all
User.delete_all

puts "Cleared existing data!"

puts "Creating default user..."

james = User.create!(first_name: "James", last_name: "Shuttleworth", email: "james@james.com", password: "password", password_confirmation: "password")

jade = User.create!(first_name: "Jade", last_name: "Derche", email: "jade@jade.com", password: "password", password_confirmation: "password")

sian = User.create!(first_name: "Sian", last_name: "Derche", email: "sian@sian.com", password: "password", password_confirmation: "password")

annabel = User.create!(first_name: "Annabel", last_name: "Shuttleworth", email: "annabel@annabel.com", password: "password", password_confirmation: "password")

ellie = User.create!(first_name: "Ellie", last_name: "Shuttleworth", email: "ellie@ellie.com", password: "password", password_confirmation: "password")

milo = User.create!(first_name: "Milo", last_name: "Vingoe", email: "milo@milo.com", password: "password", password_confirmation: "password")

admir = User.create!(first_name: "Admir", last_name: "Vingoe", email: "admir@admir.com", password: "password", password_confirmation: "password")

dricus = User.create!(first_name: "Dricus", last_name: "Vingoe", email: "dricus@dricus.com", password: "password", password_confirmation: "password")

khamzat = User.create!(first_name: "Khamzat", last_name: "Vingoe", email: "khamzat@khamzat.com", password: "password", password_confirmation: "password")

fin = User.create!(first_name: "Fin", last_name: "Vingoe", email: "fin@fin.com", password: "password", password_confirmation: "password")



james.save!
jade.save!
sian.save!
annabel.save!
ellie.save!
milo.save!
admir.save!
dricus.save!
khamzat.save!
fin.save!

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
  status: "Scheduled"
)

Tournament.create!(
  name: "Winter Squash Open",
  start_date: "2025-12-01 10:00:00",
  end_date: "2025-12-05 18:00:00",
  location: "City Sports Center",
  description: "A thrilling competition to close out the year.",
  bracket_type: "Double Elimination",
  max_players: 32,
  min_players: 16,
  created_by_user_id: User.first.id,
  status: "Scheduled"
)

Tournament.create!(
  name: "Spring Squash Fest",
  start_date: "2025-03-01 10:00:00",
  end_date: "2025-03-05 18:00:00",
  location: "Uptown Squash Club",
  description: "A fun-filled festival to welcome spring.",
  bracket_type: "Round Robin",
  max_players: 32,
  min_players: 8,
  created_by_user_id: User.first.id,
  status: "Scheduled"
)

Tournament.create!(
  name: "Fall Squash Classic",
  start_date: "2025-09-01 10:00:00",
  end_date: "2025-09-05 18:00:00",
  location: "Downtown Squash Club",
  description: "A classic tournament to welcome the fall season.",
  bracket_type: "Single Elimination",
  max_players: 32,
  min_players: 8,
  created_by_user_id: User.first.id,
  status: "Scheduled"
)

Tournament.create!(
  name: "Brixton Squash",
  start_date: "2025-09-01 10:00:00",
  end_date: "2025-09-05 18:00:00",
  location: "Downtown Squash Club",
  description: "A classic tournament to welcome the fall season.",
  bracket_type: "Single Elimination",
  max_players: 32,
  min_players: 8,
  created_by_user_id: User.first.id,
  status: "Scheduled"
)

sixth = Tournament.create!(
  name: "Clapham Squash",
  start_date: "2025-09-01 10:00:00",
  end_date: "2025-09-05 18:00:00",
  location: "Downtown Squash Club",
  description: "A classic tournament to welcome the fall season.",
  bracket_type: "Single Elimination",
  max_players: 32,
  min_players: 8,
  created_by_user_id: User.first.id,
  status: "Scheduled"
)
Tournament.create!(
  name: "Fall Squash Classic",
  start_date: "2025-09-01 10:00:00",
  end_date: "2025-09-05 18:00:00",
  location: "Downtown Squash Club",
  description: "A classic tournament to welcome the fall season.",
  bracket_type: "Single Elimination",
  max_players: 32,
  min_players: 8,
  created_by_user_id: User.first.id,
  status: "Completed"
)

sixth.save!

puts "#{Tournament.count} tournaments created!"


TournamentPlayer.create!(
  tournament_id: Tournament.first.id,
  user_id: james.id,
  status: "registered"
)

TournamentPlayer.create!(
  tournament_id: Tournament.second.id,
  user_id: james.id,
  status: "registered"
)

TournamentPlayer.create!(
  tournament_id: sixth.id,
  user_id: james.id,
  status: "registered"
)

TournamentPlayer.create!(
  tournament_id: Tournament.fourth.id,
  user_id: james.id,
  status: "registered"
)

TournamentPlayer.create!(
  tournament_id: Tournament.fifth.id,
  user_id: james.id,
  status: "registered"
)



TournamentPlayer.create!(
  tournament_id: Tournament.last.id,
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

TournamentPlayer.create!(
  tournament_id: Tournament.first.id,
  user_id: annabel.id,
  status: "registered"
)

TournamentPlayer.create!(
  tournament_id: Tournament.first.id,
  user_id: ellie.id,
  status: "registered"
)

TournamentPlayer.create!(
  tournament_id: Tournament.first.id,
  user_id: milo.id,
  status: "registered"
)

TournamentPlayer.create!(
  tournament_id: Tournament.first.id,
  user_id: admir.id,
  status: "registered"
)

TournamentPlayer.create!(
  tournament_id: Tournament.first.id,
  user_id: dricus.id,
  status: "registered"
)

puts "Creating #{TournamentPlayer.count} tournament players..."

puts "Seeding complete!"
