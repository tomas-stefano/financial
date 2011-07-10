module Financial
  class Cost
    attr_accessor :name, :method_name, :value, :date

    def initialize(cost_name, *arguments)
      arguments.flatten!
      @name = cost_name.to_s.split('_').join(' ').capitalize
      @method_name = cost_name
      @value = arguments.shift
      @date = Date.today
    end

    def in_date(user_date=nil)
      @date = Financial::FinancialDate.new(user_date).date
      self
    end

    def format_value
      "- #{Financial.locale.format_coin(value)}"
    end

    def +(cost)
      self.value + cost.value
    end

    def is_a_received_deposit?(account)
      false
    end

    def ==(cost)
      self.value == cost.value and self.method_name == cost.method_name
    end
  end
end