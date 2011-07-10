require 'spec_helper'

module Financial
  describe Account do
    let(:reserved_bank) { Financial.account_manager.new_account(:reserved_bank) }
    let(:bank_account) { Account.new([:bank_account, {:as=>"Bank Account"}]) }
    let(:super_bank_account) { Account.new(:super_bank_account) }

    describe '#name' do
      it 'should return the name of the account' do
        reserved_bank.name.should equal :reserved_bank
      end

      it 'should assign the name when pass many args' do
        bank_account.name.should equal :bank_account
      end
    end

    describe '#banner' do
      it 'should assign the name with spaces and capitalize if dont pass a name' do
        reserved_bank.banner.should == "Reserved bank"
      end

      it 'should assign the banner as a option' do
        bank_account.banner.should == 'Bank Account'
      end
    end

    describe '#total' do
      it 'should return zero if dont pass any value' do
        bank_account.total.should be 0
      end

      it 'should return the value passed in argument' do
        bank_account.total(400)
        bank_account.total.should be 400
      end
    end

    describe '#total_costs' do
      it 'should calculate total costs' do
        bank_account.costs do
          credit_card 100
          other_costs 1040
        end
        bank_account.total_costs.should be 1140
      end

      it 'should calculate total costs counting parcels' do
        bank_account.costs do
          credit_card 1000
          parcels(10).of(300)
        end
        bank_account.total_costs.should be 4000
      end

      it 'should calculate floats too' do
        bank_account.costs do
          credit 500.55
          other  100.10
        end
        bank_account.total_costs.should == 600.65
      end

      it 'should assign to instance variable' do
        bank_account.costs { some_costs 300 }
        bank_account.total_costs
        bank_account.instance_variable_get(:@total_costs).should be 300
      end

      it 'should return zero when dont have costs' do
        bank_account.total_costs.should be 0
      end

      it 'should assign a instance variable zero if dont have revenues' do
        bank_account.total_costs
        bank_account.instance_variable_get(:@total_costs).should be 0
      end

      it 'should count the deposits with costs' do
        bank_account.costs { credit 1000 }
        bank_account.deposits { deposit(2000) }
        bank_account.total_costs.should be 3000
      end

      it 'should count the deposits' do
        bank_account.deposits { deposit(100) }
        bank_account.total_costs.should be 100
      end
    end

    describe '#deposits' do
      it 'should have some deposits' do
        bank_account.deposits do
          deposit(100)
        end
        bank_account.deposits.should have(1).item
      end
    end

    describe '#taxes' do
      it 'should have some taxes' do
        bank_account.revenues do
          billing(100).tax(1)
        end
        bank_account.taxes.should == [Tax.new(:billing, 100)]
      end

      it 'should ignore the revenues without taxes' do
        bank_account.revenues { billing 100 }
        bank_account.taxes.should == []
      end
    end

    describe '#total_revenues' do
      it 'should return the revenue value if have one revenue only' do
        bank_account.revenues { billing_value 500 }
        bank_account.total_revenues.should be 500
      end

      it 'should return calculate the revenue value' do
        bank_account.revenues do
          billing_value 499
          other_value 1000
        end
        bank_account.total_revenues.should be 1499
      end

      it 'should return zero when dont have revenues' do
        bank_account.total_revenues.should be 0
      end

      it 'should assign a instance variable' do
        bank_account.revenues { a_revenue 100 }
        bank_account.total_revenues
        bank_account.instance_variable_get(:@total_revenues).should be 100
      end

      it 'should assign a instance variable zero if dont have revenues' do
        bank_account.total_revenues
        bank_account.instance_variable_get(:@total_revenues).should be 0
      end
    end

    describe '#costs' do
      it 'should return an empty costs when does not have any costs' do
        reserved_bank.costs.should be_empty
      end

      it 'should return an Costs' do
        reserved_bank.costs.should be_instance_of(Costs)
      end

      context 'with parcels' do
        before { reserved_bank.costs { parcels(2).of(400) } }

        it 'should split all the parcels in cost' do
          reserved_bank.costs.all? { |cost| cost.class == Cost }.should be_true
        end

        it 'should keep the value of the parcel and setting in the cost' do
          reserved_bank.costs.all? { |cost| cost.value.equal?(400) }.should be_true
        end

        it 'should keep the dates of the parcel and setting in the cost' do
          reserved_bank.costs.all? { |cost| cost.date.is_a?(Date) }.should be_true
        end
      end

      context 'with a block' do
        let(:cost) { reserved_bank.costs.first }
        before do
          Financial.locale = :en
          reserved_bank.costs do
            a_cost(400).in_date('09/20/2011')
          end
          cost.should_not be_nil
        end

        it 'cost should be instance of Cost' do
          cost.should be_instance_of(Financial::Cost)
        end

        it 'cost should set the cost_name' do
          cost.name.should == 'A cost'
        end

        it 'cost should set the value' do
          cost.value.should equal 400
        end

        it 'cost should set the date' do
          cost.date.should == Date.new(2011, 9, 20)
        end
      end
    end

    describe '#revenues' do
      it 'should return an empty revenues when does not have revenues' do
        reserved_bank.revenues.should be_empty
      end

      it 'should return an Array' do
        reserved_bank.revenues.should be_instance_of(Financial::Revenues)
      end

      context 'with a block should push a revenue that:' do
        let(:revenue) { reserved_bank.revenues.first }
        before do
          reserved_bank.revenues do
            a_revenue(100).in_date('7/17/2011')
          end
          revenue.should_not be_nil
        end

        it 'contain a instance of Financial::Revenue' do
          revenue.should be_instance_of(Financial::Revenue)
        end

        it 'contain the name of the revenue' do
          revenue.name.should == 'A revenue'
        end

        it 'contain the value of the revenue' do
          revenue.value.should equal 100
        end

        it 'contain the date of the revenue' do
          revenue.date.should == Date.civil(2011, 7, 17)
        end
      end
    end

    describe '#balances' do
      before do
        reserved_bank.total 300
      end

      it 'should include a balance that subtract costs' do
        reserved_bank.costs { credit(100).in_date('1/1/2011')}
        reserved_bank.calculate_balances.should include_balance(200).in_date('1/1/2011')
      end

      it 'should include a balance that subtract deposits' do
        reserved_bank.deposits { deposit(900).in_date('1/2/2011')}
        reserved_bank.calculate_balances.should include_balance(-600).in_date('1/2/2011')
      end

      it 'should include a balance that subtract the tax' do
        reserved_bank.revenues { bill(100).in_date('1/2/2011').tax(0.1).in_date('1/3/2011') }
        reserved_bank.calculate_balances.should include_balance(390).in_date('1/3/2011')
      end

      it 'should include a balance that add a revenue' do
        reserved_bank.revenues { bill(1000).in_date('4/4/2011') }
        reserved_bank.calculate_balances.should include_balance(1300).in_date('4/4/2011')
      end

      it 'should include a balance that add a revenue and subtract a cost in the same date' do
        reserved_bank.revenues { bill(900).in_date('3/3/2011')}
        reserved_bank.costs { credit(600).in_date('3/3/2011')}
        reserved_bank.calculate_balances.should include_balance(600).in_date('3/3/2011')
        reserved_bank.balances.should include_balance(600).in_date('3/3/2011')
      end

      it 'should include a balance that subtract costs, deposits and taxes in the same date' do
        reserved_bank.revenues { bill(1000).in_date('5/5/2011').tax(0.1).in_date('5/5/2011')}
        reserved_bank.costs { credit(400).in_date('5/5/2011') }
        reserved_bank.deposits { deposit(600).in_date('5/5/2011') }
        reserved_bank.calculate_balances.should have(1).item
        reserved_bank.calculate_balances.should include_balance(200.0).in_date('5/5/2011')
      end

      it 'should include a balance for the reserved_bank that receives a deposit' do
        bank_account.total 110.0
        reserved_bank.deposits { deposit(150).in_account(:bank_account).in_date('9/20/2011') }
        bank_account.balances.should include_balance(260.0).in_date('9/20/2011')
      end

      it 'should include a balance of all receiveds deposits in the same date' do
        super_bank_account.total 4000
        account :other_super_account do
          deposits do
            deposit(100).in_account(:super_bank_account).in_date('9/20/2011')
          end
        end
        account :hiper do
          deposits do
            deposit(1000).in_account(:super_bank_account).in_date('9/20/2011')
          end
        end
        super_bank_account.balances.should include_balance(5100).in_date('9/20/2011')
      end
    end

    describe '#costs_in_date' do
      let(:date) { Date.civil(2011, 7, 1) }

      it 'should return all costs in date' do
        bank_account.costs do
          credit_card(400).in_date '7/1/2011'
          other(300).in_date '3/4/2011'
        end
        bank_account.costs_in_date(date).should == [bank_account.costs.first]
      end

      it 'should return an empty array when dont have costs' do
        bank_account.costs_in_date(date).should == []
      end
    end

    describe '#revenues_in_date' do
      let(:date) { Date.civil(2011, 7, 1) }

      it 'should return all costs in date' do
        bank_account.revenues do
          bill(400).in_date '7/1/2011'
          salary(300).in_date '3/4/2011'
        end
        bank_account.revenues_in_date(date).should == [bank_account.revenues.first]
      end

      it 'should return the receiveds deposits for bank_account' do
        bank_account.deposits { deposit(100).in_account(:super_bank_account).in_date('7/1/2011') }
        super_account = Financial.account_manager.new_account(:super_bank_account)
        Financial.account_manager.should_receive(:accounts).and_return([super_account, bank_account])
        super_account.revenues_in_date(date).should == [bank_account.deposits.first]
      end

      it 'should return an empty array when dont have costs' do
        bank_account.revenues_in_date(date).should == []
      end
    end

    describe '#events_in_date' do
      let(:date) { Date.civil(2011, 7, 1) }

      it 'should return all costs in date' do
        bank_account.costs do
          credit_card(400).in_date '7/1/2011'
        end
        bank_account.events_in_date(date).should == [bank_account.costs.first]
      end

      it 'should return all revenues in date' do
        bank_account.revenues do
          service(500).in_date '7/1/2011'
        end
        bank_account.events_in_date(date).should == [bank_account.revenues.first]
      end

      it 'should return all deposits in date' do
        bank_account.deposits do
          deposit(500).in_date('7/1/2011')
          deposit(1000).in_date('7/1/2011')
        end
        bank_account.events_in_date(date).should == bank_account.deposits
      end
    end

    describe '#last_balance_in_date' do
      let(:date) { Date.civil(2011, 6, 14)}

      it 'should return the toal when not have balances' do
        bank_account.last_balance_in_date(date).should be(0)
      end

      it 'should return the last balance for the exactly date' do
        bank_account.costs { a_cost(400).in_date '6/14/2011' }
        bank_account.last_balance_in_date(date).should be -400
      end

      it 'should return the last balance that is less than date' do
        bank_account.costs { other_cost(980).in_date '6/01/2011'}
        bank_account.last_balance_in_date(date).should be -980
      end

      it 'should not return a old balance that is not the last balance for date' do
        bank_account.costs do
          a_cost(700).in_date '6/01/2011'
          credit(300).in_date '6/12/2011'
        end
        bank_account.last_balance_in_date(date).should be -1000
      end
    end

    describe '.find' do
      it 'should find the reserved_bank account' do
        bank_account
        Account.find(:name => :reserved_bank).should == reserved_bank
      end

      it 'should find the reserved_bank account pass a stirng value' do
        bank_account
        Account.find(:name => 'reserved_bank').should == reserved_bank
      end
    end
  end
end