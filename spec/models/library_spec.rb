require 'spec_helper'

describe Library do
  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  before do
    @library = Library.new(user_id: user.id, title: "Library test", category_id: category.id)
  end
  
  subject { @library }

  it { should respond_to(:user_id) }
  it { should respond_to(:title) }
  it { should respond_to(:category_id) }
  it { should respond_to(:description) }
  it { should respond_to(:privacy) }

  describe "when user_id is not present" do
    before { @library.user_id = nil }
    it { should_not be_valid }
  end

  describe "when title is not present" do
    before { @library.title = nil }
    it { should_not be_valid }
  end

  describe "when category_id is not present" do
    before { @library.category_id = nil }
    it { should_not be_valid }
  end
    
  describe "with blank title" do
    before { @library.title = " " }
    it { should_not be_valid }
  end

  describe "with blank description" do
    before { @library.description = " " }
    it { should be_valid }
  end

  describe "with title that is too long" do
    before { @library.title = "a" * 61 }
    it { should_not be_valid }
  end

  describe "with description that is too long" do
    before { @library.description = "a" * 201 }
    it { should_not be_valid }
  end

end
