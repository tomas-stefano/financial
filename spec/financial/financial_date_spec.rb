require 'spec_helper'

module Financial
  describe FinancialDate do
    describe '#date' do
      it 'should return today date when pass nil argument' do
        FinancialDate.new(nil).date.should == Date.today
      end

      context 'in portuguese date' do
        let(:date) {
          Financial.locale = :pt
          FinancialDate.new('14/09/2011')
        }

        it 'should parse and return the day' do
          date.day.should equal 14
        end

        it 'should parse and return the month' do
          date.month.should equal 9
        end

        it 'should parse and return year' do
          date.year.should equal 2011
        end
      end

      context 'in english date' do
        let(:date) {
          Financial.locale = :en
          FinancialDate.new('08/19/2011')
        }

        it 'should parse and return the day' do
          date.day.should equal 19
        end

        it 'should parse and return the month' do
          date.month.should equal 8
        end

        it 'should parse and return year' do
          date.year.should equal 2011
        end

      end
    end
  end
end
