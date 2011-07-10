require 'spec_helper'

describe Financial do
  describe '.locale' do
    it 'should return the default locale if dont have a locale' do
      Financial.locale.should == Financial::Locale.new(:en)
    end

    it 'should assign and get the locale name' do
      Financial.locale = :pt
      Financial.locale.should == Financial::Locale.new(:pt)
    end
  end
end