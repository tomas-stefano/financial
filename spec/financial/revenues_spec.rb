require 'spec_helper'

module Financial
  describe Revenues do
    let(:revenues) { Revenues.new }
    describe '#method_missing' do
      it 'should create a cost when passing an argument' do
        revenues.super_revenue(100).should be_instance_of(Revenue)
      end

      it 'should raise error when pass without argument' do
        expect {
          revenues.a_bill
        }.to raise_error Financial::RevenueWithoutValue, "Revenue: a_bill don't have a value. Pass a value!"
      end
    end
  end
end