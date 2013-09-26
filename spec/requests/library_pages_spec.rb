require 'spec_helper'

describe "LibraryPages" do

  subject { page }

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit libraries_path
    end

    it { should have_title(full_title('Libraries')) }
    it { should have_selector('h1', text: 'Libraries') }

    describe "pagination" do

      before do
        20.times { FactoryGirl.create(:library, user: user) }
        visit libraries_path
      end
      after do
        Library.delete_all
      end

      it { should have_selector('div.pagination') }

      it "should list each library" do
        Library.paginate(page: 1).each do |library|
          expect(page).to have_selector('li', text: library.title)
          expect(page).to have_link(library.title, library_path(library.id) )
        end
      end
    end
  end

  describe "library page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:category) { FactoryGirl.create(:category) }
    let!(:library) { FactoryGirl.create(:library, user: user, category: category, description: 'Description') }

    before do
      sign_in user
      visit library_path(user.libraries.first)
    end

    it { should have_selector('h1', text: library.title) }
    it { should have_content(library.category.name) }
    it { should have_content(library.description) }
    
    describe "editing library" do
      before { click_link 'Edit' }

      it { should have_selector('h1', text: 'Edit library') }
    end

    describe "editing another user's library" do
      let(:another_user) { FactoryGirl.create(:user) }
      before { visit edit_library_path(user.libraries.first) }

      specify { expect(response).to redirect_to(root_url) }
    end

  end
end