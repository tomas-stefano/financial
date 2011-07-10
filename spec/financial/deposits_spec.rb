require 'spec_helper'

module Financial
  describe Deposits do
    describe '#deposit' do
      let(:deposits) { Deposits.new(:super_account) }

      it 'should create a cost when passing an argument' do
        deposits.deposit(100).should be_instance_of(Deposit)
      end

      it 'should get the account name' do
        deposits.deposit(200).account_name.should be :super_account
      end

      it 'should raise error when pass without argument' do
        expect {
          deposits.deposit
        }.to raise_error ArgumentError
      end
    end
  end
end