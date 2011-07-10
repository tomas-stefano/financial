module Financial
  class PrintTable
    attr_accessor :account_name, :account, :initial_date, :final_date
    attr_reader :financial_tables

    def initialize(name)
      current_date = Date.today
      @account_name = name
      @account = Financial.account_manager.find_account(account_name)
      @initial_date = current_date
      @final_date = current_date
      @financial_tables = []
    end

    def from(initial_date_value)
      @initial_date = Financial::FinancialDate.new(initial_date_value).date
      self
    end

    def to(final_date_value)
      @final_date = Financial::FinancialDate.new(final_date_value).date
      self
    end

    def print!
      @financial_tables = @account.collect{|account_instance| FinancialTable.new(account_instance, self)}
      @financial_tables.each do |financial_table|
        puts financial_table.header
        puts financial_table.to_s
        puts
      end
    end
  end
end