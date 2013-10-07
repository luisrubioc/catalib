require 'spec_helper'

describe Item do
  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  let(:library) { FactoryGirl.create(:library, user: user, category: category) }

  before do
    @item = library.items.build(title: "An item")
  end
  
  subject { @item }

  it { should respond_to(:library_id) }
  it { should respond_to(:title) }
  it { should respond_to(:rating) }
  it { should respond_to(:status) }
  it { should respond_to(:lent) }
  it { should respond_to(:notes) }

  describe "when library_id is not present" do
    before { @item.library_id = nil }
    it { should_not be_valid }
  end

  describe "when title is not present" do
    before { @item.title = nil }
    it { should_not be_valid }
  end

  describe "with a rating that is not integer" do
    before { @item.rating = 5.1 }
    it { should_not be_valid }
  end
    
  describe "with negative rating" do
    before { @item.rating = -1 }
    it { should_not be_valid }
  end

  describe "with rating greater than 10" do
    before { @item.rating = 11 }
    it { should_not be_valid }
  end

  describe "with status is not present" do
    before { @item.status = nil }
    it { should_not be_valid }
  end

  describe "with not allowed status" do
    before { @item.status = "fake_status" }
    it { should_not be_valid }
  end

  describe "with lent value that is too long" do
    before { @item.lent = "a" * 31 }
    it { should_not be_valid }
  end

  describe "with notes too long" do
    before { @item.notes = "a" * 401 }
    it { should_not be_valid }
  end
end
