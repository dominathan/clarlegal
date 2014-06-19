require 'spec_helper'

describe Client do

  let(:user) { FactoryGirl.create(:user) }
  before { @client = user.clients.build(client_name: "fuckme",
                     client_email: "fuck@fuck.com", client_zip_code: 63333, user_id: user.id) }

  subject { @client }

  it { should respond_to(:client_name)}
  it { should respond_to(:client_email)}
  it { should respond_to(:client_zip_code)}
  it { should respond_to(:user_id)}
  its(:user) { should eq user}

  it { should be_valid }

  describe "when user_id is not present" do
    before { @client.user_id = nil }
    it { should_not be_valid }
  end

end
