FactoryGirl.define do

  factory :lawfirm do
    sequence(:firm_name) { |n| "New Test Firm LLC#{n}" }
    password                   "password"
    password_confirmation      "password"
  end

  factory :user do
    association            :lawfirm
    first_name             "Jimmy"
    last_name              "McJim"
    sequence(:email) { |n| "test#{n}@example.com" }
    password               "password"
    password_confirmation  "password"
    activated              true
    activated_at           Time.zone.now
  end

  factory :client do
    association           :user
    first_name            "Jo"
    last_name             "Bill"
    email                 "jo@bill.com"
    street_address        "222 Biilly Drive"
    city                  "Aust"
    state                 "AL"
    phone_number          "(303) 303-3003"
    zip_code              "33333"
  end

  factory :practicegroup do
    association                  :lawfirm
    sequence(:group_name)  { |n| "practice_group#{n}" }
  end

  factory :case do
    association           :client
    practicegroup_id      1
    sequence(:name) { |n| "Me v. World#{n}" }
    open                  false
    court                 "Jeff Co"
    primary_email         "reminderemail@test.com"
  end

  factory :closeout do
    association                     :case
    total_recovery                  5
    total_gross_fee_received        4
    total_out_of_pocket_expenses    3
    referring_fees_paid             2
    total_fee_received              1
    fee_type                        "Contingency"
    date_fee_received               Date.today
  end

  factory :overhead do
    association                     :lawfirm
    lawfirm_id                      111
    rent                            3000000
    utilities                       0
    guaranteed_salaries             0
    hard_costs                      0
    other                           0
    billable_hours_per_lawyer       2000
    number_of_billable_staff        20
    rate_per_hour                   75
  end

  factory :origination do
    association                      :case
    sequence(:referral_source) { |n| "source#{n}" }
  end

  factory :open_case do
    association                     :client
    sequence(:name)            { |n| "Me v. World#{n}" }
    open                            false
  end

  factory :fee do
    association                     :case
    fee_type                        "Contingency"
    high_estimate                   5
    medium_estimate                 3
    low_estimate                    1
    retainer                        3
    cost_estimate                   2
    referral                        1
  end

  factory :timing do
    association                     :case
    estimated_conclusion_fast       "Mon, 16 Feb 2015".to_date
    estimated_conclusion_expected   "Mon, 16 Feb 2015".to_date + 1.year
    estimated_conclusion_slow       "Mon, 16 Feb 2015".to_date + 2.years
  end

end


