require 'spec_helper'

describe "HomePages" do

  subject {page}

    describe "Home page" do

      before { visit root_path }
      it { should have_content('CLARLEGAL') }
      it { should have_title(full_title('Home')) }
    end


  describe "Contact page" do
    before { visit contact_path }
    it { should have_content ('Contact') }
    it { should have_title(full_title('Contact')) }
  end

  describe "About page" do
    before {visit about_path}
    it { should have_content('About') }
    it { should have_title(full_title('About Us')) }
  end



end
