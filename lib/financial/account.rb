module Financial
  class Account
    attr_accessor :name, :banner

    def initialize(*arguments)
      arguments.flatten!
      options = arguments.last.is_a?(Hash) ? arguments.pop : {}
      @name = arguments.shift
      raise RuntimeError, "Pass a name to account" unless @name
      @banner = options[:as] || @name.to_s.split('_').join(' ').capitalize
      @costs = Costs.new
      @revenues = Revenues.new
      @deposits = Deposits.new(@name)
      @balances = []
      @total = 0
    end

    def total(value=nil)
      return @total unless value
      @total = value
    end

    def deposits(&block)
      @deposits.instance_eval(&block) if block_given?
      @deposits
    end

    def costs(&block)
      @costs.instance_eval(&block) if block_given?
      @costs.replace_parcels_with_costs!
      @costs
    end

    def revenues(&block)
      @revenues.instance_eval(&block) if block_given?
      @revenues
    end

    def taxes
      revenues.collect { |revenue| revenue.tax }.compact
    end

    def calculate_balances
      @balances = BalanceCalculation.new(self).calculate!
    end
    alias :balances :calculate_balances

    def all_costs
      [costs, deposits, taxes].flatten.sort_by { |event| event.date }
    end

    def all_revenues
      [revenues, received_deposits].flatten
    end

    def unique_events_dates
      events.collect { |event| event.date }.uniq.sort
    end

    def events
      [all_costs, all_revenues].flatten
    end

    def events_in_date(date)
      events.select {|event| event.date == date }
    end

    def costs_in_date(date)
      all_costs.select { |cost| cost.date == date }
    end

    def revenues_in_date(date)
      all_revenues.select { |revenue| revenue.date == date }
    end

    def total_costs
      calculate(:all_costs)
    end

    def total_revenues
      calculate(:all_revenues)
    end

    def calculate(method_name)
      objects_instances = self.send(method_name)
      costs_or_revenues_sum = if objects_instances.empty?
        0
      else
        objects_instances.collect { |object_instance| object_instance.value }.inject(:+)
      end
      self.instance_variable_set("@#{method_name.to_s.gsub('all', 'total')}", costs_or_revenues_sum)
    end

    # FIXME: Fix a bug that dups all received_deposits
    #
    def received_deposits
      account_manager.accounts.collect { |account| account.deposits}.flatten.select do |deposit|
        deposit.account_to_deposit.equal?(@name)
      end
    end

    def ==(other_account)
      name == other_account.name
    end

    # OPTIMIZE ME: if this have hundreds balances will slow things down :\
    #
    def last_balance_in_date(date)
      all_balances_for_date = balances.select { |balance| balance.date <= date }
      if all_balances_for_date.empty?
        total
      else
        all_balances_for_date.last.value
      end
    end

    def find_balance_in_date(date)
      balances.find { |balance| balance.date == date }
    end

    def self.find(options)
      Financial.account_manager.accounts.find { |account| account.name == options[:name].to_sym}
    end

    def account_manager
      Financial.account_manager
    end
  end
end