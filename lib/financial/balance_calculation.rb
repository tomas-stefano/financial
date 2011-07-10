module Financial
  class BalanceCalculation
    attr_accessor :balances, :account, :revenues, :costs, :unique_events_dates

    def initialize(account_instance)
      @balances = []
      @account = account_instance
      @costs = @account.all_costs
      @revenues = @account.revenues
      @unique_events_dates = account.unique_events_dates
      @total = account.total
    end

    def calculate!
      unique_events_dates.collect do |date|
        @date = date
        @total -= calculate_costs
        @total += calculate_revenues
        Balance.new(@total, date)
      end
    end

    def calculate_costs
      costs_in_date = account.costs_in_date(@date)
      return 0 if costs_in_date.empty?
      costs_in_date.collect { |cost| cost.value }.inject(:+)
    end

    def calculate_revenues
      revenues_in_date = account.revenues_in_date(@date)
      return 0 if revenues_in_date.empty?
      revenues_in_date.collect {|event| event.value }.inject(:+)
    end
  end
end