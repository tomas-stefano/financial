require 'spec_helper'

Financial.locale = :en
include Financial::PerCent

account :my_account do
  total -2000
end

account :mega_bank_account, :as => 'Bank Account' do
  total 1099

  deposits do
    deposit(2000).in_account(:my_account)
  end

  costs do
    a_cost(400).in_date('7/30/2011')
    other_cost(500).in_date('7/31/2011')
    other_other_cost(100) # will use current date if dont pass a date option
    parcels(2).of(500).every_day(6).beginning(:september)
  end

  revenues do   # or  billing do
    a_revenue(300).tax(:decreases => 200).in_date('09/20/2011')  # The profit here will be 100
    other_revenue(500).in_date('07/15/2011').tax(6.per_cent).in_date('08/20/2011')
    bill(2000).tax(12.per_cent)
  end

end

describe 'account :my_account' do
  let(:bank_account) { Financial::Account.find(:name => :mega_bank_account) }

  describe '#name' do
    it 'should have :bank_account as a name' do
      bank_account.name.should equal :mega_bank_account
    end
  end

  describe '#total' do
    it 'should have a total' do
      bank_account.total.should equal 1099
    end
  end

  describe '#costs' do
    it 'should have many costs' do
      bank_account.costs.should have(5).items
    end
  end

  describe '#total_costs' do
    it 'should calculate the total costs' do
      bank_account.total_costs.should == 4470.0
    end
  end

  describe '#revenues' do
    it 'should have some revenues' do
      bank_account.revenues.should have(3).items
    end
  end

  describe '#total_revenues' do
    it 'should calculate the total revenues' do
      bank_account.total_revenues.should equal 2800
    end
  end

  describe '#taxes' do
    it 'should have some taxes' do
      bank_account.taxes.should have(3).items
    end
  end
end