require 'spec_helper'

module Financial
  describe Cost do
    describe '#name' do
      it 'should assign the name in a string capitalize and with space' do
        Cost.new(:a_cost, 400).name.should == "A cost"
      end
    end

    describe '#method_name' do
      it 'should assign the method name in string' do
        Cost.new(:other_cost, 599).method_name.should equal :other_cost
      end
    end

    describe '#date' do
      it 'should return the date of today' do
        Cost.new(:other_cost, 400).date.should == Date.today
      end
    end

    describe '#value' do
      it 'should assign the value passing an Array' do
        Cost.new(:cost, [400]).value.should equal 400
      end

      it 'should assign the value when not passing an array' do
        Cost.new(:super_cost, 1_000).value.should equal 1_000
      end
    end

    describe '#format_value' do
      it 'should format the value passing an - sign' do
        Cost.new(:cost, [400]).format_value.should == "- 400,00"
      end

      it 'should pass the cents value' do
        Cost.new(:super_cost, 1_000.99).format_value.should == "- 1000,99"
      end
    end

    describe '#+' do
      it 'should sum all the values for cost' do
        (Cost.new(:credit, 100) + Cost.new(:card, 400)).should be 500
      end
    end

    describe '#in_date' do
      let(:credit_card) { Cost.new(:credit_card, 199) }
      context 'when is in portuguese' do
        it 'should get and set the day/month/year format' do
          Financial.locale = :pt
          credit_card.na_data('20/12/2011').date.should == Date.civil(2011, 12, 20)
        end
      end

      context 'dont pass any args or nil arguments' do
        it 'should return the default date' do
          Financial.locale = :en
          credit_card.in_date.date.should == Date.today
        end

        it 'should return the today date if a date is nil' do
          Financial.locale = :en
          credit_card.in_date(nil).date.should == Date.today
        end
      end

      context 'when is in english' do
        it 'should get and set the month/day/year format' do
          Financial.locale = :en
          credit_card.in_date('12/20/2011').date.should == Date.civil(2011, 12, 20)
        end
      end
    end
  end
end