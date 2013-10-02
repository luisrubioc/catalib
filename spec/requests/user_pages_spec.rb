require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title(full_title( I18n.t(:all_users) )) }
    it { should have_content( I18n.t(:all_users) ) }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link( I18n.t(:delete) ) }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link(I18n.t(:delete), href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link(I18n.t(:delete), match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link(I18n.t(:delete), href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:category) { FactoryGirl.create(:category) }
    let!(:l1) { FactoryGirl.create(:library, user: user, category: category) }
    let!(:l2) { FactoryGirl.create(:library, user: user, category: category) }

    before { visit user_path(user) }

    it { should have_title(user.name) }
    it { should have_content(user.name) }

    describe "libraries" do
      it { should have_content(l1.category.name) }
      it { should have_content(l2.category.name) }
      it { should have_content(user.libraries.count) }
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content( I18n.t(:sign_up) ) }
    it { should have_title(full_title( I18n.t(:sign_up) )) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { I18n.t(:create_user) }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in I18n.t('activerecord.attributes.user.name'),
                with: "Example User"
        fill_in I18n.t('activerecord.attributes.user.email'),
                with: "user@example.com"
        fill_in I18n.t('activerecord.attributes.user.password'),
                with: "foobar"
        fill_in I18n.t(:confirmation),
                with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link( I18n.t(:sign_out) ) }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
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
      it { should have_content( I18n.t(:update_profile) ) }
      it { should have_title( I18n.t(:edit_user) ) }
      it { should have_link(I18n.t(:change), href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button I18n.t(:save_changes) }

      it { should have_content( I18n.t(:error) ) }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in I18n.t('activerecord.attributes.user.name'),
                with: new_name
        fill_in I18n.t('activerecord.attributes.user.email'),
                with: new_email
        fill_in I18n.t('activerecord.attributes.user.password'),
                with: user.password
        fill_in I18n.t(:confirm_password), 
                with: user.password
        click_button I18n.t(:save_changes)
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link(I18n.t(:sign_out), href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end