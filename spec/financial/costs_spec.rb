require 'spec_helper'

module Financial
  describe Costs do
    let(:costs) { Costs.new }
    describe '#method_missing' do
      it 'should create a cost when passing an argument' do
        costs.super_cost(100).should be_instance_of(Cost)
      end

      it 'should raise error when pass without argument' do
        expect {
          costs.credit_card
        }.to raise_error Financial::CostWithoutValue, "Cost: credit_card don't have a value. Pass a value!"
      end
    end
  end
end