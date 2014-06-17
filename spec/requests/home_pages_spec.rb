require 'spec_helper'

describe "HomePages" do

    describe "Home page" do

    it "should have the content 'Claregal'" do
      visit '/home_pages/home'
      expect(page).to have_content('Claregal')
    end

    it "should have the title 'Home'" do
      visit '/home_pages/home'
      expect(page).to have_title("Claregal | Home")
    end
  end

  describe "Contact page" do

    it "should have the content 'Contact'" do
      visit '/home_pages/contact'
      expect(page).to have_content('Contact')
    end

    it "should have the title 'Home'" do
      visit '/home_pages/contact'
      expect(page).to have_title("Claregal | Contact")
    end
  end
end
