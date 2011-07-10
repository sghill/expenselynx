require 'spec_helper'

describe Store do
  let(:name) { nil }

  subject do
    store = Store.new(:name => name)
    store.valid?
    store
  end

  context "with name 'Target'" do
    let(:name) { 'Target' }
    its(:expense_categories) { should be_an_instance_of(Array) }
    its(:user_store_expense_categories) { should be_an_instance_of(Array) }
    its(:users) { should be_an_instance_of(Array) }
    it { should be_valid }
  end

  context "without a name" do
    let(:name) { nil }

    it { should be_invalid }
    it { should have_error_message("can't be blank").on(:name) }
  end

  context "with a name the same as an existing store" do
    let(:name) { 'Old Navy' }
    before { Store.create(:name => name) }

    it { should be_invalid }
    it { should have_error_message("has already been taken").on(:name) }
  end

  context "with a name the same but different case as an existing store" do
    let(:name) { 'la shish' }

    before { Store.create(:name => 'La Shish') }

    it { should be_invalid }
    it { should have_error_message("has already been taken").on(:name) }
  end

  context "with name 'Typical Party Store'" do
    let(:name) { 'Typical Party Store' }

    before { subject.save! }

    it { should == Store.find_by_name("typical party stoRE") }
    it { should == Store.find_by_name(:case_sensitive => true, :name => "Typical Party Store") }

    it "should not create store when one exists case insensitive" do
      Store.find_or_create_by_name(:case_sensitive => false, :name => 'typical party stoRE')
    end

    it "should not create when one with same name exists" do
      should == Store.find_or_create_by_name('Typical Party Store')
    end

    it "should search and find store by partial name case insensitive" do
      found_store = Store.search_by_name("typ").first
      should == found_store
    end
  end
end
