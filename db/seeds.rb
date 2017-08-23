Meetup.destroy_all
User.destroy_all

10.times do
  Meetup.create(name: "#{Faker::Pokemon.move}", location: "#{Faker::HarryPotter.location}", description: "#{Faker::StarWars.wookiee_sentence}", creator_id: 1 + rand(5))
end

5.times do
  User.create(provider: "#{Faker::HarryPotter.location}", uid: 1 + rand(2500), username: "#{Faker::DrWho.character}", email: "#{Faker::Pokemon.move}@#{Faker::StarTrek.location}.com", avatar_url:"http://via.placeholder.com/200x200")
end
