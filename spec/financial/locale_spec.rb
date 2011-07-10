require 'spec_helper'

module Financial
  describe Locale do
    describe '#initialize' do
      it 'should raise error if pass a locale that dont exist' do
        expect {
          Locale.new(:dont_exist)
        }.to raise_error LocaleDontAvailable
      end
    end

    describe '#name' do
      it 'should keep the name of the locale' do
        Locale.new(:pt).name.should equal :pt
      end
    end

    describe '#to_coin' do
      it 'should return a dollar for english locale' do
        Locale.new(:en).to_coin(10).should == "$ 10,00"
      end

      it 'should return a dollar for english locale with float' do
        Locale.new(:en).to_coin(10.10).should == "$ 10,10"
      end

      it 'should return a reais for portuguese locale' do
        Locale.new(:pt).to_coin(0.99).should == "R$ 0,99"
      end

      it 'should return a dollar for english locale with negative numbers' do
        Locale.new(:en).to_coin(-100.10).should == "$ -100,10"
      end
    end
  end
end