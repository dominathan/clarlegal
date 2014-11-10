require 'spec_helper'

describe "PasswordResets" do

  let(:user) { FactoryGirl.create(:user) }

  it "emails user when requesting password reset" do
    visit signin_path
    click_link "Click Here"
    fill_in "Email", with: user.email
    click_button "Submit"
    current_path.should eq(root_path)
    page.should have_content("Email sent with password reset instructions")
    last_email.to.should include(user.email)
  end

  it "does not email invalid user when requesting password reset" do
    visit signin_path
    click_link "Click Here"
    fill_in "Email", :with => "nobody@example.com"
    click_button "Submit"
    current_path.should eq(password_resets_path)
    page.should_not have_content("Email sent")
    last_email.should be_nil
  end

  xit "updates the user password when confirmation matches" do
    user = FactoryGirl.create(:user, :reset_digest => "something", :reset_sent_at => 1.hour.ago)
    visit edit_password_reset_path(user.reset_digest)
    fill_in "Password", :with => "foobar"
    click_button "Update Password"
    page.should have_content("Password doesn't match confirmation")
    fill_in "Password", :with => "foobar"
    fill_in "Password confirmation", :with => "foobar"
    click_button "Update Password"
    page.should have_content("Password has been reset")
  end

  xit "reports when password token has expired" do
    user = FactoryGirl.create(:user, :reset_digest => "something", :reset_sent_at => 5.hour.ago)
    visit edit_password_reset_path(user.reset_digest, save_and_open_page)
    fill_in "Password", :with => "foobar"
    fill_in "Password confirmation", :with => "foobar"
    click_button "Update Password"
    page.should have_content("Password reset has expired")
  end

  xit "raises record not found when password token is invalid" do
    lambda {
      visit edit_password_reset_path("invalid")
    }.should raise_exception(ActiveRecord::RecordNotFound)
  end

end
