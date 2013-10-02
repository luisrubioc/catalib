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
    let(:category) { FactoryGirl.create(:category, name: "Movies", description: "Cinema category") }
    let!(:library) { FactoryGirl.create(:library, user: user, category: category, description: "Description") }

    before do
      sign_in user
      visit library_path(library.id)
    end

    it { should have_selector('h1', text: library.title) }
    it { should have_content(library.category.name) }
    it { should have_content(library.description) }
    
    describe "editing library" do
      let(:new_title)       { "New title" }
      let(:new_category)    { "Movies" }
      let(:new_description) { "New description" }
      before do
        click_link 'Edit'
        fill_in "Title",        with: new_title
        select  new_category,        from: "library_category_id"
        fill_in "Description",  with: new_description
        #fill_in "Privacy",      with: "foobar"
        click_button "Save changes"
      end

      specify { expect(library.reload.title).to  eq new_title }
      specify { expect(library.reload.category.name).to  eq new_category }
      specify { expect(library.reload.description).to  eq new_description }
    end

    describe "editing another user's library" do
      let(:another_user) { FactoryGirl.create(:user) }
      before do
        sign_in another_user
        visit edit_library_path(library)
      end

      it { should have_selector('h3', text: "Catalib things") }
    end

    describe "submitting requests as another user" do
      let(:another_user) { FactoryGirl.create(:user) }
      before { sign_in another_user, no_capybara: true }

      describe "submitting a PATCH request to the Libraries#update action" do
        before { patch library_path(library) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a DELETE request to the Libraries#destroy action" do
        before { delete library_path(library) }
        specify { expect(response).to redirect_to(root_url) }
      end     
    end
  end
end