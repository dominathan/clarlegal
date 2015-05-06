require 'spec_helper'

describe "New case page" do

  subject { page }

  describe "new case page" do
    let(:user) { FactoryGirl.create(:user) }
    before {
      sign_in user
      visit '/new_case'
    }
    #blocking because correct_user only allows for you to see your own profile
    it { should have_content('New Client?') }
  end

end
