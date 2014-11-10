require "spec_helper"

describe UserMailer do
  describe "account_activation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }


    it "renders the headers" do
      mail.subject.should eq("Account Activation")
      mail.to.should eq(["test@example.com"])
      mail.from.should eq(["noreply@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Jimmy McJim")
      mail.body.encoded.should match(user.activation_token)
      mail.body.encoded.should match(CGI::escape(user.email))
    end
  end

  describe "password_reset" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.password_reset(user) }

    it "renders the headers" do
      user.create_reset_digest
      mail.subject.should eq("Password Reset Instructions")
      mail.to.should eq(["test@example.com"])
      mail.from.should eq(["noreply@example.com"])
    end

    it "renders the body" do
      user.create_reset_digest
      mail.body.encoded.should match("To reset your password click the link below")
      mail.body.encoded.should match(user.reset_token)
      mail.body.encoded.should match(CGI::escape(user.email))
    end
  end

end
