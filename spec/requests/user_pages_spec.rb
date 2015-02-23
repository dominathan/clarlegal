require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    #blocking because correct_user only allows for you to see your own profile
    xit { should have_content(User.full_name(user)) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create Account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "First Name",         with: "Example User"
        fill_in "Last Name",         with: "Nothing"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "password"
        fill_in "Password Confirmation", with: "password"
      end

      describe "after clicking submit button" do
        ActionMailer::Base.deliveries.clear
        it "should send an email" do
          expect { click_button submit }.to change(ActionMailer::Base.deliveries, :count).by(1)
        end

        describe 'should redirect to home page' do
          subject { page }
          it { should have_link('Sign in')}
        end
      end

      describe "and not activating account with email" do
        before do
          visit signin_path
          fill_in "Email",    with: "user@example.com"
          fill_in "Password",    with: "password"
          click_button "Sign in"
        end

        describe "should not be able to sign in" do
          it { should have_link('Sign in') }
          xit { should have_content("Account not activated") }
        end
      end

      describe "after activating account through email link" do
        before do
          visit signin_path
          fill_in "Email",    with: "user@example.com"
          fill_in "Password",    with: "password"
          click_button "Sign in"
        end

        let(:user) { User.find_by(email: 'user@example.com').activate }
        xit { should have_link('Sign out'); save_and_open_page }
        xit { should have_selector('div.alert.alert-success', text: 'Welcome') }

        xit "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      xit { should have_content("Update your profile") }
      it { should have_title("Edit user") }
    end

    describe "with invalid information" do
      before { click_button "Save Changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_first_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "First Name",             with: new_first_name
        fill_in "Last Name",             with: new_first_name
        fill_in "Email",            with: new_email
        fill_in "Password:",         with: user.password
        fill_in "Password Confirmation", with: user.password
        click_button "Save Changes"
      end

      xit { should have_title(new_first_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.first_name).to  eq new_first_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end



end
