require 'spec_helper'

describe "ItemPages" do

  subject { page }

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }
    let(:category) { FactoryGirl.create(:category) }
    let(:library) { FactoryGirl.create(:library, 
                                        user: user,
                                        category: category) }

    before { sign_in user }
    
    describe "pagination" do

      before do
        20.times { FactoryGirl.create(:item, library: library) }
        visit library_path(library)
      end
      after do
        Item.delete_all
      end

      it { should have_selector('h3', text: 'Items') }
      it { should have_selector('div.pagination') }

      it "should list each item" do
        Item.paginate(page: 1).each do |item|
          expect(page).to have_selector('li', text: item.title)
          expect(page).to have_link(item.title, item_path(item.id) )
        end
      end
    end
  end

  describe "item page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:category) { FactoryGirl.create(:category) }
    let(:library) { FactoryGirl.create(:library, 
                                        user: user,
                                        category: category) }
    let(:item) { FactoryGirl.create(:item, library: library) }

    before do
      sign_in user
      visit item_path(item)
    end

    it { should have_selector('h1', text: item.title) }
    it { should have_content(item.category.name) }
    it { should have_content(item.description) }
    
    describe "editing item" do
      let(:new_title)       { "New title" }
      let(:new_category)    { "Movies" }
      let(:new_description) { "New description" }
      before do
        click_link 'Edit'
        fill_in "Title",        with: new_title
        select  new_category,   from: "item_category_id"
        fill_in "Description",  with: new_description
        fill_in "Privacy",      with: "foobar"
        click_button "Save changes"
      end

      specify { expect(item.reload.title).to  eq new_title }
      specify { expect(item.reload.category.name).to  eq new_category }
      specify { expect(item.reload.description).to  eq new_description }
    end

    describe "editing another user's item" do
      let(:another_user) { FactoryGirl.create(:user) }
      before do
        sign_in another_user
        visit edit_item_path(item)
      end

      it { should have_selector('h3', text: "Catalib things") }
    end

    describe "submitting requests as another user" do
      let(:another_user) { FactoryGirl.create(:user) }
      before { sign_in another_user, no_capybara: true }

      describe "submitting a PATCH request to the Libraries#update action" do
        before { patch item_path(item) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a DELETE request to the Libraries#destroy action" do
        before { delete item_path(item) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end