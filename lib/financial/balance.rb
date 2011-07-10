module Financial
  class Balance
    attr_accessor :value, :date, :name

    def initialize(balance_value, balance_date)
      @name = Financial.locale.balance_name
      @value = balance_value
      @date = balance_date.is_a?(Date) ? balance_date : Financial::FinancialDate.new(balance_date).date
    end
  end
end