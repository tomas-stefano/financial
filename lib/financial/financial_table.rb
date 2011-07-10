module Financial
  class FinancialTable
    include Terminal::Table::TableHelper
    attr_reader :header, :account, :print_table, :locale

    extend Forwardable

    def_delegator :@print_table, :initial_date, :initial_date
    def_delegator :@print_table, :final_date, :final_date
    def_delegator :@account, :total, :total
    def_delegator :@account, :events_in_date, :events_in_date
    def_delegator :@account, :find_balance_in_date, :find_balance_in_date
    def_delegator :@locale, :table_headings, :headings
    def_delegator :@locale, :date_to_s, :date_to_s
    def_delegator :@locale, :to_coin, :to_coin

    def initialize(account_instance, print_table_instance)
      @account = account_instance
      @print_table = print_table_instance
      @locale = Financial.locale
      @header = @locale.header_for(@account, @print_table.initial_date, @print_table.final_date)
    end

    def positive?
      @positive
    end

    def to_s
      financial_table = self
      @financial_table = table do
        self.headings = financial_table.headings
        add_row(financial_table.initial_balance)
        add_separator
        financial_table.add_rows(self)
        add_separator
        add_row(financial_table.final_balance)
      end
    end

    def add_rows(terminal_table)
      initial_date.upto(final_date).each do |date|
        add_rows_in_date(date, :using => terminal_table)
      end
    end

    def add_rows_in_date(date, options)
      @date = date
      @terminal_table = options[:using]
      @events = events_in_date(date)
      unless @events.empty?
        add_events_to_table
        @terminal_table.add_separator
        add_balance_to_table
      end
    end

    def add_events_to_table
      @events.each_with_index do |event, index|
        @event = event
        @index = index
        @terminal_table.add_row [row_date, row_name, row_value, '']
      end
    end

    def add_balance_to_table
      balance = find_balance_in_date(@date)
      @terminal_table.add_row ['', balance.name, hifen, locale.format_coin(balance.value)]
      @terminal_table.add_separator
    end

    def initial_balance
      [date_to_s(initial_date), locale.initial_balance, hifen, to_coin(total)]
    end

    def final_balance
      [date_to_s(final_date), locale.final_balance, hifen, to_coin(account.last_balance_in_date(final_date))]
    end

    def hifen
      '--------'
    end

    def row_date
      if @index == 0
        date_to_s(@event.date)
      else
        '' # dont pass nothing if is the same date
      end
    end

    def row_name
      received_deposit.first
    end

    def row_value
      received_deposit.last
    end

    def received_deposit
      name = @event.name
      value = @event.format_value
      if @event.is_a_received_deposit?(@account)
        name = "#{locale.received_deposit_name}: #{@event.account_name}"
        value = value.gsub('-', '+')
      end
      [name, value]
    end
  end
end