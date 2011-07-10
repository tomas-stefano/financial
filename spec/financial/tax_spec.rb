require 'spec_helper'

module Financial
  describe Tax do
    let(:tax) { Tax.new(:billing, 500) }

    describe '#name' do
      it 'should return the name capitalized' do
        tax.name.should == "Billing"
      end
    end

    describe '#value' do
      it 'should return the value' do
        tax.value.should be 500
      end
    end

    describe '#date' do
      it 'should return the date of today' do
        Tax.new(:billing, 400).date.should == Date.today
      end
    end

    describe '#in_date' do
      let(:billing) { Tax.new(:a_billing, 199) }
      context 'when is in portuguese' do
        it 'should get and set the day/month/year format' do
          Financial.locale = :pt
          billing.na_data('20/12/2011').date.should == Date.civil(2011, 12, 20)
        end
      end

      context 'when is in english' do
        it 'should get and set the month/day/year format' do
          Financial.locale = :en
          billing.in_date('12/20/2011').date.should == Date.civil(2011, 12, 20)
        end
      end
    end
  end
end