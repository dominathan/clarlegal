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
    User.create!(name: "liz",
                 email: "liz@test.com",
                 password: "password",
                 password_confirmation: "password",
                 lawfirm_id: 1)
    User.create!(name: "mike",
                 email: "mike@test.com",
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
    practice_group_names = ["Commercial Litigation", "Single Tort",
                            "Medical Malpractice", "Worker's Compensation",
                            "Automotive"]
    5.times do |n|
      Practicegroup.create!(lawfirm_id: 1,
                            group_name: practice_group_names[n])
    end
  end

  desc "add 25 Matter References (CaseType model)"
  task populate: :environment do
    matter_reference_list = ['Airplane Accident', 'Plane Crash', 'SUV Rollover', 'Car Accident', 'Motorcycle Accident',
                              'Truck Accident', 'Fire & Explosion', 'Construction Accident', 'Employment Discrimination',
                              'Bad Faith', 'Medical Malpractice', 'Car/Truck/Motorcycle Accident', 'Nursing Home Neglect',
                              'Product Liability', 'Property and Casualty Insurance', 'Underinsured Motorist',
                              'Uninsured Motorist', 'Maritime', 'Jones Act', 'Premises Liability', "Slips & Falls",
                              'Spinal Chord Injury', 'Traumatic Brain Injury', "Worker's Compensation", 'Wrongful Death']
    25.times do |n|
      CaseType.create!(mat_ref: matter_reference_list[n+1],
                      lawfirm_id: 1)
    end
  end

  desc "add 30 staff to lawfirm 1"
  task populate: :environment do
    30.times do
      position_list = ['Paralegal', 'Attorney','Accountant','Staff','Responsible Attorney']
      Staffing.create!(full_name: Faker::Name.name,
                        position: position_list[Random.rand(0..4)],
                        hourly_rate: (Random.rand(10..45)*10),
                        lawfirm_id: 1)
    end
  end

  desc "add 10 clients to data-set"
  task populate: :environment do
    15.times do
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

  desc "add 50 cases to data-set"
  task populate: :environment do
    50.times do
      plaintiff = Faker::Name.name
      defendant = Faker::Name.name
      opposing_attorney = Faker::Name.name
      judge = Faker::Name.name
      Case.create!(client_id: Random.rand(1..10),
                    name: plaintiff+" V. "+defendant,
                    practice_group: Practicegroup.find_by(id: Random.rand(1..5)).group_name,
                    type_of_matter: CaseType.find_by(id: Random.rand(1..24)).mat_ref,
                    court: 'Alabama Circuit Court',
                    judge: judge,
                    case_number: Random.rand(0..100000).to_s,
                    opposing_attorney: opposing_attorney,
                    description: Faker::Lorem.paragraph,
                    open: true)
    end
  end

  desc "add 50 fees - 1 per case"
  task populate: :environment do
    fee_type = ['Hourly','Fixed Fee', 'Contingency']
    payment_likelihood = ['High', 'Medium', "Low"]
    50.times do |n|
      Fee.create!(case_id: n+1,
                  fee_type: fee_type[Random.rand(0..3)],
                  high_estimate: Random.rand(1..4000)*1000,
                  #try to make it line up if fix fee but dont want to waste time on it now
                  medium_estimate: if fee_type == 'Fixed Fee'
                                      medium_estimate = high_estimate
                                   else
                                      Random.rand(500..(1000-1)*1000)
                                    end,
                  low_estimate: if fee_type != 'Fixed Fee'
                                    Random.rand(0..499)*1000
                                else
                                    low_estimate = high_estimate
                                end,
                  payment_likelihood: payment_likelihood[Random.rand(0..2)],
                  retainer: Random.rand(0..100)*100,
                  cost_estimate: Random.rand(0..100)*1000,
                  referral: Random.rand(0..100)*1000)
    end
  end

  desc "add 50 Timings - 1 per case"
  task populate: :environment do
    50.times do |n|
      fast_conclusion = Random.rand(0..24)
      expected_conclusion = fast_conclusion+Random.rand(0..24)
      slow_conclusion = fast_conclusion+expected_conclusion+Random.rand(0..24)
      Timing.create!(case_id: n+1,
                      date_opened: Date.new(Random.rand(2008..2014),Random.rand(1..12),Random.rand(1..28)),
                      case_filed: Date.new(Random.rand(2008..2014),Random.rand(1..12),Random.rand(1..28)),
                      estimated_conclusion_fast: fast_conclusion,
                      estimated_conclusion_expected: expected_conclusion,
                      estimated_conclusion_slow: slow_conclusion)
    end
  end






end
