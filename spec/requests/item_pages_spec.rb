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

      it { should have_selector('h3', text: I18n.t(:items)) }
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
    it { should have_content(item.rating) }
    it { should have_content(item.status) }
    it { should have_content(item.lent) }
    it { should have_content(item.notes) }
    
    describe "editing item" do
      let(:new_title)   { "New title" }
      let(:new_rating)  { 8 }
      let(:new_status)  { "abandoned" }
      let(:new_lent)    { "Gorrón" }
      let(:new_notes)   { Faker::Lorem.sentence(5) }
      before do
        click_link 'Edit'
        fill_in "Title",   with: new_title
        fill_in "Rating",  with: new_rating
        fill_in "Status",  with: new_status
        fill_in "Lent",    with: new_lent
        fill_in "Notes",   with: new_notes
        click_button I18n.t(:save_changes)
      end

      specify { expect(item.reload.title).to  eq new_title }
      specify { expect(item.reload.rating).to  eq new_rating }
      specify { expect(item.reload.status).to  eq new_status }
      specify { expect(item.reload.lent).to  eq new_lent }
      specify { expect(item.reload.notes).to  eq new_notes }
    end

    describe "editing another user's item" do
      let(:another_user) { FactoryGirl.create(:user) }
      before do
        sign_in another_user
        visit edit_item_path(item)
      end

      it { should have_selector('h3', text: AppConfig['app_name']) }
    end

    describe "submitting requests as another user" do
      let(:another_user) { FactoryGirl.create(:user) }
      before { sign_in another_user, no_capybara: true }

      describe "submitting a PATCH request to the Items#update action" do
        before { patch item_path(item) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a DELETE request to the Items#destroy action" do
        before { delete item_path(item) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end