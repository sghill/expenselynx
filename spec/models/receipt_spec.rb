require 'spec_helper'

describe Receipt do
  it "should have many participants" do
    receipt = Factory(:chipotle_burrito)
    receipt.participants.should be_an_instance_of(Array)
  end

  it "should support a note" do
    receipt = Factory(:chipotle_burrito)
    receipt.note.should be_nil
  end

  context "with 2 unexpensed, 1 expensed and 3 unexpensable for same user" do
    subject { user.receipts }

    let(:user) { Factory :user }

    let!(:chipotle_burrito) { Factory :chipotle_burrito, :expensable => true,
                                      :expensed => false,
                                      :user => user,
                                      :total => 0.50 }

    let!(:baja_tacos) { Factory :baja_tacos, :expensable => true,
                                :expensed => false,
                                :user => user,
                                :total => 0.50 }

    let!(:starbucks_coffee) { Factory :starbucks_coffee, :expensable => true,
                                      :expensed => true,
                                      :user => user,
                                      :total => 0.50 }

    let!(:oil_filter) { Factory :oil_filter, :expensable => false,
                                :expensed => false,
                                :user => user,
                                :total => 0.50 }

    let!(:another_oil_filter) { Factory :oil_filter, :expensable => false,
                                        :expensed => false,
                                        :user => user,
                                        :total => 0.50,
                                        :store => oil_filter.store }

    let!(:yet_another_oil_filter) { Factory :oil_filter, :expensable => false,
                                            :expensed => false,
                                            :user => user,
                                            :total => 0.50,
                                            :store => oil_filter.store }

    its(:unexpensed) { should include chipotle_burrito, baja_tacos }
    its(:expensed) { should include starbucks_coffee }
    its(:unexpensable) { should include oil_filter, another_oil_filter, yet_another_oil_filter }

    its(:recent) { should == [yet_another_oil_filter, another_oil_filter, oil_filter, starbucks_coffee, baja_tacos] }
  end
end
