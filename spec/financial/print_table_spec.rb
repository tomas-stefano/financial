require 'spec_helper'

module Financial
  describe PrintTable do
    let(:print_table) { PrintTable.new(:my_account) }
    let(:print_all) { PrintTable.new(:all) }

    describe '#account_name' do
      it 'should return the name of the account to run' do
        print_table.account_name.should equal :my_account
      end

      it 'should return all accounts to run' do
        print_all.account_name.should equal :all
      end
    end

    describe '#account' do
      let(:my_bank_account) { Financial.account_manager.new_account(:my_bank_account) }

      it 'should return an array of accounts instances' do
        my_bank_account
        PrintTable.new(:my_bank_account).account.should == [my_bank_account]
      end

      it 'should return all accounts when pass :all option' do
        my_bank_account
        print_all.account.should equal AccountManager.instance.accounts
      end
    end

    describe '#initial_date' do
      it 'should return the current date for defaults' do
        print_table.initial_date.should == Date.today
      end
    end

    describe '#final_date' do
      it 'should return the current date for defaults' do
        print_table.final_date.should == Date.today
      end
    end

    describe '#from' do

      it 'should be possible to use portuguese dates' do
        Financial.locale = :pt
        print_table.from('20/12/2011')
        print_table.initial_date.should == Date.civil(2011, 12, 20)
        Financial.locale = :en
        Financial.locale
      end

      it 'should assign the @from accessor' do
        print_table.from('02/02/2002')
        print_table.initial_date.should == Date.civil(2002, 2, 2)
      end
    end

    describe '#to' do

      it 'should be possible to use portuguese dates' do
        Financial.locale = :pt
        print_table.to('20/12/2011')
        print_table.final_date.should == Date.civil(2011, 12, 20)
        Financial.locale = :en
        Financial.locale
      end

      it 'should assign the @from accessor' do
        print_table.to('02/02/2002')
        print_table.final_date.should == Date.civil(2002, 2, 2)
      end
    end
  end
end