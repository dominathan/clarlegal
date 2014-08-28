require 'spec_helper'

describe Client do

  let(:user) { FactoryGirl.create(:user) }
  before { @client = user.clients.build(first_name: "jo", last_name: "jo",
                     email: "jo@jo.com", zip_code: 63333, user_id: user.id,
                     city: "Aust", state: 'AL') }

  subject { @client }

  it { should respond_to(:first_name)}
  it { should respond_to(:last_name)}
  it { should respond_to(:email)}
  it { should respond_to(:street_address)}
  it { should respond_to(:city)}
  it { should respond_to(:state)}
  it { should respond_to(:zip_code)}
  it { should respond_to(:user_id)}
  its(:user) { should eq user}

  it { should be_valid }

  describe "when user_id is not present" do
    before { @client.user_id = nil }
    it { should_not be_valid }
  end

end
