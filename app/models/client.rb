class Client < ActiveRecord::Base
  belongs_to :user
  has_many :cases
  has_many :billings

  accepts_nested_attributes_for :billings, :reject_if => :all_blank
  #all attributes must be filled for billings or it will not save

  validates :user_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i || ""
  validates :email, format: { with: VALID_EMAIL_REGEX }

  def self.all_full_name_last_first(user)
    #used in _staff_fields for collection select of LastName, FirstName
    final_name_list = []
    user.lawfirm.clients.each do |name|
      final_name_list << [name.last_name, name.first_name].compact.join(", ")
    end
    final_name_list.sort
  end

  def self.full_name_last_first(first_name, last_name)
    [last_name, first_name].compact.join(", ")
  end

  #returns all ACTUAL expenses and revenue associated with client to clients#show
  def self.client_profitability_actual(client)
    profit = set_client_variables
    closed_cases = client.cases.where(open: false)
    closed_cases.each do |ca|
      profit[0] += ca.closeouts.last.total_gross_fee_received
      profit[1] += ca.closeouts.last.total_out_of_pocket_expenses
      profit[1] += ca.closeouts.last.referring_fees_paid
      #return to calculated indirect expenses once overhead calculation is included
    end
    profit[2] = profit[0] - profit[1]
    return profit
  end

  #return the average profitability of all clients for the lawfirm
    #doing this because highcharts.js does not like a single array category
  def self.all_client_profitability(user)
    all_client_profits = []
    client_list = user.lawfirm.clients
    client_list.each do |cl|
      profit = set_client_variables
      closed_cases = cl.cases.where(open: false)
      closed_cases.each do |ca|
        profit[0] += ca.closeouts.last.total_gross_fee_received
        profit[1] += ca.closeouts.last.total_out_of_pocket_expenses
        profit[1] += ca.closeouts.last.referring_fees_paid
        #return to calculated indirect expenses once overhead calculation is included
      end
      profit[2] = profit[0] - profit[1]
      all_client_profits << profit
    end
    return [all_client_profits, client_list.collect(&:full_name)]
  end

  #average Client.all_client_profitability to show avg client profitability for the firm
  def self.avg_client_profitability(client_array)
    profit = set_client_variables
    client_length = client_array[0].length
    for i in client_array[0]
      profit[0] += i[0]
    end
    for i in client_array[0]
      profit[1] += i[1]
    end
    for i in client_array[0]
      profit[2] += i[2]
    end
    for i in client_array[0]
      profit[3] += i[3]
    end
    for i in client_array[0]
      profit[4] += i[4]
    end
    avg_profit = [(profit[0].to_f/client_length).round,
                  (profit[1].to_f/client_length).round,
                  (profit[2].to_f/client_length).round,
                  (profit[3].to_f/client_length).round,
                  (profit[4].to_f/client_length).round]
    return avg_profit
  end

  #set variables used in calculating client profitability to 0
  def self.set_client_variables
    [gross_fee=0,direct_expenses=0,net_fee=0,indirect_expenses=0,net_profit=0] #could also add total_hours_worked*applicable_rate
  end


end
