module Financial
  class FinancialDate
    attr_reader :date, :day, :month, :year

    extend ::Forwardable
    def_delegator :@date, :day, :day
    def_delegator :@date, :month, :month
    def_delegator :@date, :year, :year

    def initialize(string_date)
      if string_date
        @date = Date.strptime(string_date, Financial.locale.date_format)
      else
        @date = Date.today
      end
    end
  end
end