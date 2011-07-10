# coding: utf-8
require 'spec_helper'

module Financial
  describe Balance do
    let(:balance) { Balance.new(100, '07/14/2011')}
    describe '#value' do
      it 'should get and set the value' do
        balance.value.should equal 100
      end

    end

    describe '#name' do
      after(:each) do
        Financial.locale = :en
      end

      it 'should return the the name in english' do
        Balance.new(100, '07/14/2011').name.should == 'Balance'
      end

      it 'should return the name in portuguese' do
        Financial.locale = :pt
        Balance.new(100, '17/1/2011').name.should == "Saldo"
      end
    end

    describe '#date' do
      after(:each) do
        Financial.locale = :en
      end

      it 'should get and set the date' do
        balance.date.should == Date.civil(2011, 7, 14)
      end

      it 'should not need to set date when is a Date object' do
        date = Date.civil(2011, 1, 1)
        Balance.new(100, date).date.should == date
      end
    end
  end
end