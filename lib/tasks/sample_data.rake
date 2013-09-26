namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_libraries
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@catalib.com",
                       password: "catalib",
                       password_confirmation: "catalib",
                       admin: true)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@catalib.com"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_libraries
  users = User.all(limit: 6)  

  11.times do
    title = Faker::Name.name
    category = Category.offset(rand(Category.count)).first
    description = Faker::Lorem.sentence(5)
    users.each { |user| user.libraries.create!(title: title, category: category, description: description) }
  end
end