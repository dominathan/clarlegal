require 'spec_helper'

describe "New case page" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before {
    sign_in user
    visit '/new_case'
  }

  describe "new case page" do
    it { should have_content('New Client?') }
  end

  describe "new client modal" do
    before { click_button "New Client?" }

    it { should have_content('New Client Form') }
  end

  describe "fill out new client form in modal" do
    before do
      click_button "New Client?"

      fill_in "Company",      with: 'Company'
      fill_in "First Name",   with: 'Modal'
      fill_in "Last Name",    with: 'McTesterson'

      click_button "Add Client"
    end

    it "should create a new client" do
      expect(Client.where(first_name: 'Modal')).to exist
    end
  end

end
