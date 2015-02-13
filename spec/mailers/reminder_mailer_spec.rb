require "spec_helper"

describe ReminderMailer do
  describe "#default_reminder" do
    let(:one_case) { FactoryGirl.create(:one_case) }
    let(:mail) { ReminderMailer.default_reminder(one_case.id) }


    it "renders the headers" do
      mail.subject.should eq("Reminder: Please Update Your Case")
      mail.to.should eq(["test@example.com"])
      mail.from.should eq(["noreply-clarlegal@clarlegal.com"])
    end

    # it "renders the body" do
    #   mail.body.encoded.should match("Jimmy McJim")
    #   mail.body.encoded.should match(user.activation_token)
    #   mail.body.encoded.should match(CGI::escape(user.email))
    # end
  end
end
