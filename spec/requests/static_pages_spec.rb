require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content(AppConfig['app_name']) }
    it { should have_title(full_title('')) }
    it { should_not have_title('| ' + I18n.t(:home) ) }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit root_path
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content( I18n.t(:help) ) }
    it { should have_title(full_title( I18n.t(:help) )) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content(I18n.t(:about_us)) }
    it { should have_title(full_title( I18n.t(:about_us) )) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1', text: I18n.t(:contact) ) }
    it { should have_title(full_title( I18n.t(:contact) )) }
  end


end