namespace :db do

  task populate: :environment do
    desc "Fill database with User data"
    User.create!(name: "Nathan",
                 email: "test@test.com",
                 password: "password",
                 password_confirmation: "password",
                 lawfirm_id: 1)
    User.create!(name: "Cathy",
                 email: "cathy@test.com",
                 password: "password",
                 password_confirmation: "password",
                 lawfirm_id: 1)
    User.create!(name: "Alice",
                 email: "alice@test.com",
                 password: "password",
                 password_confirmation: "password",
                 lawfirm_id: 1)
    3.times do |n|
      name  = Faker::Name.name
      email = Faker::Internet.email
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   lawfirm_id: Random.rand(1..3))
    end
  end

  desc "add lawfirm data-set"
  task populate: :environment do
    Lawfirm.create!(firm_name: "Test Firm LLC",
                  password: 'password',
                  password_confirmation: "password")
    2.times do |n|
      Lawfirm.create!(firm_name: Faker::Company.name,
                  password: 'password',
                  password_confirmation: "password")
    end
  end

  desc "add practicegroups to lawfirm data-set"
  task populate: :environment do
    5.times do |n|
      group_name = "#{n+1}-Litigation"
      Practicegroup.create!(lawfirm_id: 1,
                            group_name: group_name)
    end
  end

  desc "add 10 clients to data-set"
  task populate: :environment do
    10.times do
      Client.create!(client_name: Faker::Name.name,
                      client_street_address: Faker::Address.street_address,
                      client_city_address: Faker::Address.city,
                      client_state_address: Faker::Address.state_abbr,
                      client_zip_code: Faker::Address.zip,
                      client_phone_number: Faker::PhoneNumber.phone_number,
                      client_email: Faker::Internet.email,
                      user_id: Random.rand(1..5))
    end
  end

  desc "add 30 cases to data-set"
  task populate: :environment do
    30.times do
      plaintiff = Faker::Name.name
      defendant = Faker::Name.name
      Case.create!(client_id: Random.rand(1..10),
                    description: Faker::Lorem.sentence,
                    name: plaintiff+" V. "+defendant,
                    practice_group: Practicegroup.find_by(id: Random.rand(1..5)).group_name,
                    matter_reference: "Add Later")
    end
  end

end
