require 'spec_helper'

module Financial
  describe Deposit do
    let(:deposit) { Deposit.new(1000, :a_account_name) }

    describe '#name' do
      after(:each) do
        ensure_locale :en
      end

      it 'should return the the name in english' do
        deposit.name.should == 'Deposit: anonymous'
      end

      it 'should return the name in portuguese' do
        Financial.locale = :pt
        deposit.in_account(:super).name.should == "Deposito: super"
      end
    end

    describe '#value' do
      it 'should return the value of deposit' do
        deposit.value.should be 1000
      end
    end

    describe '#date' do
      it 'should return the current date for defaults' do
        deposit.date.should == Date.today
      end
    end

    describe '#account_name' do
      it 'should return the account name' do
        deposit.account_name.should equal :a_account_name
      end
    end

    describe '#in_account' do
      it 'should set the name of account' do
        deposit.in_account(:bank_account).account_to_deposit.should be :bank_account
      end

      it 'should set anonymous account if dont pass a account to deposit' do
        deposit.account_to_deposit.should be :anonymous
      end
    end

    describe '#is_a_received_deposit?' do
      let(:state_bank) { Account.new(:state_bank) }
      let(:country_bank) { Account.new(:country_bank) }
      let(:city_bank) { Account.new(:city_bank) }

      it 'should return false if is a deposit for that same account' do
        deposits = state_bank.deposits do
          deposit(400).in_account(:country_bank)
        end
        event = deposits.first
        event.is_a_received_deposit?(state_bank).should equal false
      end

      it 'should return false if is a received deposit but for other account' do
        deposits = city_bank.deposits do
          deposit(600).in_account(:country_bank)
        end
        deposits.first.is_a_received_deposit?(state_bank).should equal false
      end

      it 'should return true if is a return deposit to the account' do
        deposits = city_bank.deposits do
          deposit(600).in_account(:state_bank)
        end
        deposits.first.is_a_received_deposit?(state_bank).should be_true
      end
    end
  end
end