# coding: utf-8

require 'spec_helper'

module Financial
  describe FinancialTable do
    let(:account) { Account.new(:federal_bank) }
    let(:print_table) { PrintTable.new(:federal_bank) }
    let(:financial_table) { FinancialTable.new(account, print_table)}

    before do
      ensure_locale :en
      print_table.from('3/20/2011').to('4/20/2011')
    end

    describe '#header' do
      after :each do
        ensure_locale :en
      end

      it 'should add a header the account name and the periods' do
        financial_table.header.should == "Account name: Federal bank (from: 2011-03-20, to: 2011-04-20)"
      end

      it 'should add a header for portuguese dates' do
        ensure_locale :pt
        financial_table.header.should == "Nome da Conta: Federal bank (de: 20/03/2011, até: 20/04/2011)"
      end
    end
  end
end