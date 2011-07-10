require 'spec_helper'

module Financial
  describe PerCent do
    include Financial::PerCent

    describe '#per_cent' do
      it 'should return the porcentage of Fixnum value' do
        6.per_cent.should == 0.06
      end

      it 'should return the porcentage of Float Value' do
        64.4.per_cent.should == 0.644
      end

      it 'should return the porcentage in portuguese too' do
        original_locale = Financial.locale
        Financial.locale = :pt
        99.por_cento.should == 0.99
        Financial.locale = original_locale.name
      end
    end
  end
end