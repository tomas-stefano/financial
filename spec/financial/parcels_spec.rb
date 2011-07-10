# coding: utf-8
require 'spec_helper'

module Financial
  describe Parcels do
    describe '#number' do
      it 'should set and get the number of the parcels' do
        Parcels.new(6).number.should be 6
      end
    end

    describe '#name' do
      it 'should set and get the name of the parcels in english' do
        Financial.locale = :en
        Parcels.new(3).name.should == "Parcel"
      end

      it 'should set and get the name of the parcels in portuguese' do
        Financial.locale = :pt
        Parcels.new(3).name.should == "Parcela"
      end
    end

    describe 'default instances' do
      it 'should return zero as default value of the parcels' do
        Parcels.new(1).value_of_the_parcels.should be 0
      end

      it 'should return the first day as default day of the parcels' do
        Parcels.new(2).day_of_the_parcels.should be 1
      end

      it 'should return the current month of the beginning month' do
        Date.should_receive(:today).and_return(Date.civil(2011, 7, 3))
        Parcels.new(3).beginning_month.should equal 7
      end
    end

    describe '#of' do
      it 'should set the value of the parcels' do
        Parcels.new(5).of(500).value_of_the_parcels.should equal 500
      end
    end

    describe '#every_day' do
      it 'should set the day of the parcels' do
        Parcels.new(3).every_day(14).day_of_the_parcels.should equal 14
      end
    end

    describe '#beginning' do
      it 'should set the beginning month' do
        Financial.locale = :en
        Parcels.new(2).beginning(:september).beginning_month.should equal 9
      end

      it 'should be possible to set a portuguese month name' do
        Financial.locale = :pt
        Parcels.new(4).beginning(:janeiro).beginning_month.should equal 1
        Financial.locale = :en
      end

      it 'should return the current month if dont pass a beginning month' do
        Date.should_receive(:today).and_return(Date.civil(2011, 6, 1))
        Parcels.new(4).beginning_month.should equal 6
      end

      it 'should raise if dont have the month specified' do
        expect {
          Parcels.new(2).beginning(:dont_exist)
        }.to raise_error Financial::MonthDontExist
      end
    end

    describe '#choose_month_for' do
      context 'for parcels with less then twelve numbers' do
        let(:parcels) { Parcels.new(9) }
        before do
          mock_date(20, 1, 2011)
        end

        it 'should choose the exactly months' do
          parcels.choose_month_for(0).should be 1
          parcels.choose_month_for(7).should be 8
          parcels.choose_month_for(8).should be 9
        end
      end

      context 'for parcels with greater then twelve numbers' do
        let(:parcels) { Parcels.new(13) }

        before do
          mock_date(20, 6, 2011)
        end

        it 'should choose the exactly months' do
          parcels.choose_month_for(0).should be 6
          parcels.choose_month_for(6).should be 12
          parcels.choose_month_for(7).should be 1
          parcels.choose_month_for(9).should be 3
          parcels.choose_month_for(12).should be 6
        end
      end
    end

    describe '#choose_year_for' do
      it 'should choose the current year' do
        mock_date(4, 7, 2011)
        Parcels.new(2).choose_year_for(:parcel_number => 3).should be 2011
      end

      it 'should choose the next year for parcel that pass this current year' do
        mock_date(20, 6, 2011)
        Parcels.new(8).choose_year_for(:parcel_number => 7).should be 2012
      end

      it 'should choose this next years from now too' do
        mock_date(20, 8, 2011)
        parcels = Parcels.new(30)
        parcels.choose_year_for(:parcel_number => 5).should be 2012
        parcels.choose_year_for(:parcel_number => 13).should be 2012
        parcels.choose_year_for(:parcel_number => 17).should be 2013
        parcels.choose_year_for(:parcel_number => 18).should be 2013
        parcels.choose_year_for(:parcel_number => 29).should be 2014
      end
    end

    describe '#+' do
      it 'should sum a parcel with a cost' do
        (Parcels.new(2).of(500) + Cost.new(:credit_card, 300)).should be 1300
      end
    end

    describe '#to_cost' do
      let(:parcels) { Parcels.new(4).of(200) }
      let(:costs) { parcels.to_cost }
      before(:each) do
        costs.should_not be_empty
      end

      it 'should converting to many costs' do
        parcels.to_cost.should have(4).items
      end

      it 'should converting to cost with the correct value' do
        costs.all? {|cost| cost.value == 200 }.should be_true
      end

      context "with many dates" do
        let(:parcels) { Parcels.new(12).of(200).every_day(4).beginning(:july) }

        before(:each) do
          Date.should_receive(:today).at_least(:once).and_return(Date.civil(2011, 7, 2))
          Financial.locale = :en
          @costs = parcels.to_cost
        end

        it "should return the date for the first parcel" do
          @costs[0].date.should == Date.civil(2011, 7, 4)
        end

        it "should return the date for the second parcel" do
          Financial.locale = :en
          @costs[1].date.should == Date.civil(2011, 8, 4)
        end

        it "should return the date for the third parcel" do
          Financial.locale = :en
          @costs[2].date.should == Date.civil(2011, 9, 4)
        end

        it "should return the date for the fourth parcel" do
          Financial.locale = :en
          @costs[3].date.should == Date.civil(2011, 10, 4)
        end
      end
    end
  end
end