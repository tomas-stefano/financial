require 'spec_helper'

module Financial
  describe AccountManager do
    let(:account_manager) { AccountManager.instance }

    describe '.instance' do
      it 'should have the singleton pattern' do
        account_manager.should be_equal AccountManager.instance
      end
    end

    describe '#accounts' do
      it 'should initialize with an Array' do
        account_manager.accounts.should be_instance_of(Array)
      end
    end

    describe '#find_account' do
      before do
        @lucy_bank = account_manager.new_account(:lucy_bank)
        @leo_bank = account_manager.new_account(:leo_bank)
      end

      it 'should find the account specified' do
        account_manager.find_account(:lucy_bank).should == [@lucy_bank]
      end

      it 'should find all the accounts when pass :all option' do
        account_manager.find_account(:all).should equal account_manager.accounts
      end

      it 'should find all the accounts when pass :all option' do
        account_manager.find_account(:todas).should equal account_manager.accounts
      end
    end
  end
end