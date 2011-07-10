require 'spec_helper'

module Financial
  describe Revenue do
    let(:revenue) { Revenue.new(:salary, 500) }

    describe '#name' do
      it 'should return the name capitalized' do
        revenue.name.should == "Salary"
      end

      it 'should return the name capitalized with spaces' do
        Revenue.new(:my_precious_salary, 400).name.should == "My precious salary"
      end
    end

    describe '#method_name' do
      it 'should set the method name' do
        revenue.method_name.should equal :salary
      end
    end

    describe '#value' do
      it 'should return the value' do
        revenue.value.should be 500
      end
    end

    describe '#format_value' do
      it 'should format the value passing an - sign' do
        Revenue.new(:cost, 400).format_value.should == "+ 400,00"
      end

      it 'should pass the cents value' do
        Revenue.new(:super_cost, 1_000.99).format_value.should == "+ 1000,99"
      end
    end

    describe '#date' do
      it 'should return the today date' do
        revenue.date.should == Date.today
      end
    end

    describe '#in_date' do
      it 'should return the date in english format' do
        Financial.locale = :en
        revenue.in_date('6/19/2011').date.should == Date.civil(2011, 6, 19)
      end

      it 'should return the date in portuguese format' do
        Financial.locale = :pt
        revenue.in_date('20/06/2011').date.should == Date.civil(2011, 6, 20)
      end
    end

    describe '#tax' do
      it 'should return a tax' do
        revenue.tax(0.06).should be_instance_of(Financial::Tax)
      end

      it 'should set the method name' do
        revenue.tax(1.08).method_name.should == :salary
      end

      it 'should set the name' do
        revenue.tax(1.08).name.should == "Salary"
      end

      it 'should set calculate the value multiplying the revenue value by the tax' do
        revenue.tax(0.12).value.should == 60.0 # 500 * 0.12
      end

      it 'should calculate the value decreasing the tax' do
        revenue.tax(:decreases => 10).value.should == 10
      end

      it 'should persist the value if dont have args' do
        revenue.tax(1)
        revenue.tax.value.should be 500
      end

      it 'should set the instance variable name' do
        revenue.tax(0.10)
        revenue.instance_variable_get(:@tax).should be_instance_of(Financial::Tax)
      end
    end
  end
end