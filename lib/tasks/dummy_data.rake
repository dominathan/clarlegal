namespace :db do

  task populate: :environment do
    desc "Fill database with User data"
    User.create!(first_name: "Nathan",
                 last_name: "Hall",
                 email: "test@test.com",
                 password: "password",
                 password_confirmation: "password",
                 activated: true,
                 activated_at: Time.zone.now,
                 lawfirm_id: 1)
    User.create!(first_name: "Cathy",
                  last_name: "Wright",
                 email: "cathy@test.com",
                 password: "password",
                 password_confirmation: "password",
                 activated: true,
                 activated_at: Time.zone.now,
                 lawfirm_id: 1)
    User.create!(first_name: "Alice",
                  last_name: "Walther",
                 email: "alice@test.com",
                 password: "password",
                 password_confirmation: "password",
                 activated: true,
                 activated_at: Time.zone.now,
                 lawfirm_id: 1)
    User.create!(first_name: "Liz",
                  last_name: "Hall",
                 email: "liz@test.com",
                 password: "password",
                 password_confirmation: "password",
                 activated: true,
                 activated_at: Time.zone.now,
                 lawfirm_id: 1)
    User.create!(first_name: "Mike",
                 last_name: "Hall",
                 email: "mike@test.com",
                 password: "password",
                 password_confirmation: "password",
                 activated: true,
                 activated_at: Time.zone.now,
                 lawfirm_id: 1)
    User.create!(first_name: "Will",
                  last_name: "Widman",
                 email: "widman@test.com",
                 password: "password",
                 password_confirmation: "password",
                 activated: true,
                 activated_at: Time.zone.now,
                 lawfirm_id: 1)
    User.create!(first_name: "Chris",
                  last_name: "Carson",
                 email: "chris@test.com",
                 password: "password",
                 password_confirmation: "password",
                 activated: true,
                 activated_at: Time.zone.now,
                 lawfirm_id: 1)
    User.create!(first_name: "Liza",
                  last_name: "Soydan",
                 email: "liza@test.com",
                 password: "password",
                 password_confirmation: "password",
                 activated: true,
                 activated_at: Time.zone.now,
                 lawfirm_id: 1)
    3.times do |n|
      first_name  = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      email = Faker::Internet.email
      password  = "password"
      User.create!(first_name: first_name,
                  last_name: last_name,
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
                  password_confirmation: "password",
                  user_id: 1)
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

  desc "add 15 staff to lawfirm 1"
  task populate: :environment do
    first_name = 'Cathy'
    middle_initial = (0..1).map { ('a'..'z').to_a[rand(26)] }.join.first.upcase!
      last_name = 'Wright'
      position = "Responsible Attorney"
    Staffing.create!(first_name: first_name,
                      last_name: last_name,
                      middle_initial: "S",
                      position: position,
                      position: 'Responsible Attorney',
                      hourly_rate: (Random.rand(10..45)*10),
                      email: "cathy@test.com",
                      lawfirm_id: 1)
    15.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      position_list = ['Managing Member', 'Partner','Counsel','Contract Attorney',
                        'Staff Attorney','Paralegal','Secretary', 'Responsible Attorney']
      Staffing.create!(first_name: first_name,
                        last_name: last_name,
                        middle_initial: middle_initial,
                        #Client.method used to put full_name in database
                        position: position_list[Random.rand(0..7)],
                        hourly_rate: (Random.rand(10..45)*10),
                        email: Faker::Internet.email,
                        lawfirm_id: 1)
    end
  end

  desc "add 20 clients to data-set"
  task populate: :environment do
    20.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      Client.create!(first_name: first_name,
                      last_name: last_name,
                      company: Faker::Company.name,
                      street_address: Faker::Address.street_address,
                      city: Faker::Address.city,
                      state: Faker::Address.state_abbr,
                      zip_code: Faker::Address.zip,
                      phone_number: Faker::PhoneNumber.phone_number,
                      email: Faker::Internet.email(first_name),
                      user_id: Random.rand(1..8))
    end
  end

  desc "add 100 cases to data-set"
  task populate: :environment do
    100.times do
      plaintiff = Faker::Name.name
      defendant = Faker::Name.name
      opposing_attorney = Faker::Name.name
      judge_list = ["Houston L. Brown","Donald Blankenship","Joseph Boohaker","Elisabeth French", "Helen Shores Lee", "Robert Vance"]
      Case.create!(client_id: Random.rand(1..20),
                    name: plaintiff+" v. "+defendant,
                    practicegroup_id: Practicegroup.find_by(id: Random.rand(1..5)).id,
                    court: 'Jefferson County Circuit Court - Civil',
                    judge: judge_list[Random.rand(0..4)],
                    case_number: Random.rand(10..14).to_s + " - " + Random.rand(10000..99999).to_s,
                    opposing_attorney: opposing_attorney,
                    description: Faker::Lorem.paragraph,
                    primary_email: User.find_by(id: Random.rand(1..8)).email,
                    open: true)
    end
  end

  desc "add 100 related cases randomly"
  task populate: :environment do
    100.times do
      RelatedCase.create!(case_id: Random.rand(1..100),
                          related_case_id: Random.rand(1..100))
    end
  end

  desc "add 200 Matter Types Randomly"
  task populate: :environment do
    200.times do
      Matter.create!(case_id: Random.rand(1..100),
                      case_type_id: Random.rand(1..25))
    end
  end

  desc "add 100 fees - 1 per case"
  task populate: :environment do
    fee_type = ['Hourly','Fixed Fee', 'Contingency', 'Mixed']
    payment_likelihood = ['High', 'Medium', "Low"]
    new_time = Time.local(2008,1,1,12,0,0)
    Timecop.freeze(new_time)
    100.times do |n|
      Fee.create!(case_id: n+1,
                  fee_type: fee_type[Random.rand(0..3)],
                  high_estimate: Random.rand(1000..4000)*1000,
                  #try to make it line up if fix fee but dont want to waste time on it now
                  medium_estimate: Random.rand(500..(1000-1))*1000,
                  low_estimate: Random.rand(0..499)*1000,
                  payment_likelihood: payment_likelihood[Random.rand(0..2)],
                  retainer: Random.rand(0..100)*100,
                  cost_estimate: Random.rand(0..100)*1000,
                  referral: Random.rand(0..100)*1000)
    end
    Timecop.return
  end

  desc "add 100 Timings - 1 per case"
  task populate: :environment do
    100.times do |n|
      fast_conclusion = Random.rand(0..24)
      expected_conclusion = fast_conclusion+Random.rand(0..24)
      slow_conclusion = fast_conclusion+expected_conclusion+Random.rand(0..24)
      Timing.create!(case_id: n+1,
                      date_opened: Date.new(Random.rand(2008..2014),Random.rand(1..12),Random.rand(1..28)),
                      case_filed: Date.new(Random.rand(2008..2014),Random.rand(1..12),Random.rand(1..28)),
                      estimated_conclusion_fast: Date.today + fast_conclusion.month,
                      estimated_conclusion_expected: Date.today + expected_conclusion.month,
                      estimated_conclusion_slow: Date.today + slow_conclusion.month)
    end
  end

  desc 'add 1 responsible attorney per case'
  task populate: :environment do
    head_atts = Staffing.find_by(id: 1)
    new_time = Time.local(2008,1,1,12,0,0)
    hours_expected = Random.rand(200..600)*10
    hours_actual = Random.rand(1..200) *10
    Timecop.freeze(new_time)
    100.times do |n|
      this_head_attorney = head_atts
      Staff.create!(case_id: n+1,
                    name: this_head_attorney.full_name,
                    position: this_head_attorney.position,
                    staffing_id: 1,
                    hours_actual: hours_actual,
                    hours_expected: hours_expected)
      StaffCase.create!(case_id: n+1,
                    staffing_id: Staffing.find_by(id: this_head_attorney.id).id,
                    hours_expected: hours_expected,
                    hours_actual: hours_actual,
                    current_case: true)
    end
    Timecop.return
  end


  desc 'add 200 Staff - random amount per case'
  task populate: :environment do
    new_time = Time.local(2008,1,1,12,0,0)
    Timecop.freeze(new_time)
    200.times do |n|
      staff = Staffing.find_by(id: Random.rand(2..16))
      name = User.full_name_last_first(staff)
      position = staff.position
      case_id = Random.rand(1..100)
      hours_actual = 0
      hours_expected = Random.rand(1..200)*10
      case_staff_list = Case.find_by(id: case_id).staff.collect(&:staffing_id)
      if !case_staff_list.include?(staff.id)
        Staff.create!(case_id: case_id,
                      name: name,
                      position: position,
                      hours_expected: hours_expected,
                      hours_actual: hours_actual,
                      staffing_id: Staffing.find_by(id: staff.id).id)
        StaffCase.create!(case_id: case_id,
                      hours_actual: hours_actual,
                      hours_expected: hours_expected,
                      staffing_id: Staffing.find_by(id: staff.id).id,
                      current_case: true)
      else
        next
      end
    end
    Timecop.return
  end

  desc 'add 100 originations to cases'
  task populate: :environment do
    100.times do  |n|
      referrals = ['Attorney','Client','Internet','Advertising','Reputation']
      Origination.create!(case_id: n+1,
                          referral_source: referrals[Random.rand(0..4)],
                          source_description: Faker::Lorem.sentence)
    end
  end

  desc 'add 100 conflicts and checks to cases'
  task populate: :environment do
    100.times do |n|
      conflict_check = Random.rand(0..1)
      conflict_check_date = nil
      if conflict_check == 1
        conflict_check_date = Date.new(Random.rand(2008..2014),Random.rand(1..12),Random.rand(1..28))
      end
      referring_engagement_letter = Random.rand(0..1)
      referring_engagement_letter_date = nil
      if referring_engagement_letter == 1
        Date.new(Random.rand(2008..2014),Random.rand(1..12),Random.rand(1..28))
      end
      client_engagement_letter = Random.rand(0..1)
      client_engagement_letter_date = nil
      if client_engagement_letter == 1
        client_engagement_letter_date = Date.new(Random.rand(2008..2014),Random.rand(1..12),Random.rand(1..28))
      end
      Check.create!(case_id: n+1,
                    conflict_check: conflict_check,
                    conflict_date: conflict_check_date,
                    referring_engagement_letter: referring_engagement_letter,
                    referring_engagement_letter_date: referring_engagement_letter_date,
                    client_engagement_letter: client_engagement_letter,
                    client_engagement_letter_date: client_engagement_letter_date)
    end
  end

  desc 'case closeout Random.rand(1..30)to begin making completed case graphs (case.open ==false)'
  task populate: :environment do
    75.times do |n|
      ca = Case.find_by(id: n+1)
      possible_recovery = [ca.fee.last.high_estimate, ca.fee.last.medium_estimate, ca.fee.last.low_estimate]
      actual_recovery = possible_recovery[Random.rand(0..2)]
      ca.closeouts.create!(case_id: ca.id,
                           fee_type: ca.fees.last.fee_type,
                           total_recovery: actual_recovery,
                           date_fee_received: Date.new(Random.rand(2008..2014),Random.rand(1..12),Random.rand(1..28)),
                           total_gross_fee_received: actual_recovery*0.5,
                           total_out_of_pocket_expenses: ca.fee.last.cost_estimate,
                           referring_fees_paid: ca.fee.last.referral,
                           total_fee_received: (actual_recovery*0.5 -
                                                ca.fee.last.cost_estimate -
                                                ca.fee.last.referral))
      Closeout.close_case(ca)
    end
  end

  desc 'randomly update Case Fees over Time (300)'
  task populate: :environment do
    fee_type = ['Hourly','Fixed Fee', 'Contingency', 'Mixed']
    payment_likelihood = ['High', 'Medium', "Low"]
    100.times do |n|
      new_time = Time.local(Random.rand(2008..2014),Random.rand(1..12),Random.rand(1..28),12,0,0)
      Timecop.freeze(new_time)
      Fee.create!(case_id: Random.rand(1..100),
                  fee_type: fee_type[Random.rand(0..3)],
                  high_estimate: Random.rand(1000..4000)*1000,
                  #try to make it line up if fix fee but dont want to waste time on it now
                  medium_estimate: Random.rand(500..(1000-1))*1000,
                  low_estimate: Random.rand(0..499)*1000,
                  payment_likelihood: payment_likelihood[Random.rand(0..2)],
                  retainer: Random.rand(0..100)*100,
                  cost_estimate: Random.rand(0..100)*1000,
                  referral: Random.rand(0..100)*1000)
    end
    Timecop.return
  end

  desc 'randomly update Case Staff Hours(actual) over time (500 times)'
  task populate: :environment do
     50.times do |n|
      new_time = Time.local(2008,1,1,12,0,0)
      Timecop.freeze(new_time)
      id = Random.rand(1..200)
      hours_actual = Random.rand(1..10)*10
      stf = Staff.find_by(id: id)
      hours_expected = stf.hours_expected
      stf.update_attributes(hours_actual: stf.hours_actual + hours_actual, hours_expected: hours_expected)
      StaffCase.create!(case_id: Staff.find_by(id: id).case_id,
                        hours_actual: stf.hours_actual,
                        hours_expected: hours_expected,
                        staffing_id: Staff.find_by(id: id).staffing_id,
                        current_case: true)
    end
    Timecop.return
    50.times do |n|
      new_time = Time.local(2009,1,1,12,0,0)
      Timecop.freeze(new_time)
      id = Random.rand(1..200)
      hours_actual = Random.rand(1..10)*10
      stf = Staff.find_by(id: id)
      hours_expected = stf.hours_expected
      stf.update_attributes(hours_actual: stf.hours_actual + hours_actual, hours_expected: hours_expected)
      StaffCase.create!(case_id: Staff.find_by(id: id).case_id,
                        hours_actual: stf.hours_actual,
                        hours_expected: hours_expected,
                        staffing_id: Staff.find_by(id: id).staffing_id,
                        current_case: true)
    end
    Timecop.return
    50.times do |n|
      new_time = Time.local(2010,1,1,12,0,0)
      Timecop.freeze(new_time)
      id = Random.rand(1..200)
      hours_actual = Random.rand(1..10)*10
      stf = Staff.find_by(id: id)
      hours_expected = stf.hours_expected
      stf.update_attributes(hours_actual: stf.hours_actual + hours_actual, hours_expected: hours_expected)
      StaffCase.create!(case_id: Staff.find_by(id: id).case_id,
                        hours_actual: stf.hours_actual,
                        hours_expected: hours_expected,
                        staffing_id: Staff.find_by(id: id).staffing_id,
                        current_case: true)
    end
    Timecop.return
    50.times do |n|
      new_time = Time.local(2011,1,1,12,0,0)
      Timecop.freeze(new_time)
      id = Random.rand(1..200)
      hours_actual = Random.rand(1..10)*10
      stf = Staff.find_by(id: id)
      hours_expected = stf.hours_expected
      stf.update_attributes(hours_actual: stf.hours_actual + hours_actual, hours_expected: hours_expected)
      StaffCase.create!(case_id: Staff.find_by(id: id).case_id,
                        hours_actual: stf.hours_actual,
                        hours_expected: hours_expected,
                        staffing_id: Staff.find_by(id: id).staffing_id,
                        current_case: true)
    end
    Timecop.return
    50.times do |n|
      new_time = Time.local(2012,1,1,12,0,0)
      Timecop.freeze(new_time)
      id = Random.rand(1..200)
      hours_actual = Random.rand(1..10)*10
      stf = Staff.find_by(id: id)
      hours_expected = stf.hours_expected
      stf.update_attributes(hours_actual: stf.hours_actual + hours_actual, hours_expected: hours_expected)
      StaffCase.create!(case_id: Staff.find_by(id: id).case_id,
                        hours_actual: stf.hours_actual,
                        hours_expected: hours_expected,
                        staffing_id: Staff.find_by(id: id).staffing_id,
                        current_case: true)
    end
    Timecop.return
    50.times do |n|
      new_time = Time.local(2013,1,1,12,0,0)
      Timecop.freeze(new_time)
      id = Random.rand(1..200)
      hours_actual = Random.rand(1..10)*10
      stf = Staff.find_by(id: id)
      hours_expected = stf.hours_expected
      stf.update_attributes(hours_actual: stf.hours_actual + hours_actual, hours_expected: hours_expected)
      StaffCase.create!(case_id: Staff.find_by(id: id).case_id,
                        hours_actual: stf.hours_actual,
                        hours_expected: hours_expected,
                        staffing_id: Staff.find_by(id: id).staffing_id,
                        current_case: true)
    end
    Timecop.return
    50.times do |n|
      new_time = Time.local(2014,1,1,12,0,0)
      Timecop.freeze(new_time)
      id = Random.rand(1..200)
      hours_actual = Random.rand(1..10)*10
      stf = Staff.find_by(id: id)
      hours_expected = stf.hours_expected
      stf.update_attributes(hours_actual: stf.hours_actual + hours_actual, hours_expected: hours_expected)
      StaffCase.create!(case_id: Staff.find_by(id: id).case_id,
                        hours_actual: stf.hours_actual,
                        hours_expected: hours_expected,
                        staffing_id: Staff.find_by(id: id).staffing_id,
                        current_case: true)
    end
    Timecop.return
  end

  desc 'add overhead to lawfirm 2008-2014'
  task populate: :environment do
    7.times do |n|
      year = 2008 + n
      rent = Random.rand(500000..1000000)
      salaries = Random.rand(500000..2000000)
      other = Random.rand(500000..2000000)
      billable_hours = 2000
      lawyers = 20
      lawfirm_id = 1
      technology = Random.rand(10000..50000)
      rate_per_hour = ((rent + salaries + other + technology).to_f / (billable_hours * lawyers)).round(2)
      Overhead.create!(rent: rent, utilities: 0, technology: technology, guaranteed_salaries: salaries,
                        lawfirm_id: lawfirm_id, other: other, billable_hours_per_lawyer: billable_hours,
                        year: year, number_of_billable_staff: lawyers, rate_per_hour: rate_per_hour,
                        hard_costs: 0)
    end
  end





end
