require "spec_helper"

describe ReminderMailer do
  describe "#default_reminder" do
    let(:test_case) { FactoryGirl.create(:case) }
    let(:mail) { ReminderMailer.default_reminder(test_case.id) }


    it "renders the headers" do
      mail.subject.should eq("Reminder: Please Update Your Case")
      mail.to.should eq(["reminderemail@test.com"])
      mail.from.should eq(["noreply-clarlegal@clarlegal.com"])
    end

    it "renders the body" do
      mail.body.parts.first.encoded.should include "You are receiving this email because your case details are out of date."
    end

    it "contains the correct case id" do
      mail.body.parts.first.encoded.should include "#{test_case.id}"
    end
  end
end
