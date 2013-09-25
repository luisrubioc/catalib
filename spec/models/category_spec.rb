require 'spec_helper'

describe Category do
  before do
    @category = Category.new(name: "Books", description: "Books description")
  end
  
  subject { @category }

  it { should respond_to(:name) }
  it { should respond_to(:description) }

  describe "when name is not present" do
    before { @category.name = nil }
    it { should_not be_valid }
  end
    
  describe "with blank name" do
    before { @category.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @category.name = "a" * 61 }
    it { should_not be_valid }
  end


  describe "with description that is too long" do
    before { @category.description = "a" * 201 }
    it { should_not be_valid }
  end

end
