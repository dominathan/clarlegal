require "spec_helper"

describe LawfirmMailer do
  describe "password_reset" do
    let(:mail) { LawfirmMailer.password_reset }

    xit "renders the headers" do
      mail.subject.should eq("Password reset")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    xit "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
