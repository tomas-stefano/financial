# coding: utf-8
module Financial
  class Locale
    attr_accessor :name
    attr_reader :file

    LOCALES_FOLDER = File.join(File.dirname(__FILE__), 'locales')

    def initialize(locale_name)
      raise LocaleDontAvailable unless available_locales.include?(locale_name)
      @name = locale_name
      @file = YAML.load_file(File.join(LOCALES_FOLDER, "#{@name}.yml"))
      @locale_methods = @file['methods']
      @names = @file['names']
      @date_format = @file['date']
      @table = file['table']
      send("create_alias_methods_for_#{@name}")
    end

    def right_date_format(day, month, year)
      if portuguese_language?
        "#{day}/#{month}/#{year}"
      else
        "#{month}/#{day}/#{year}"
      end
    end

    def date_to_s(date)
      right_date_format(date.day.to_s.rjust(2, '0'), date.month.to_s.rjust(2, '0'), date.year)
    end

    def initial_balance
      @table['initial_balance']
    end

    def final_balance
      @table['final_balance']
    end

    def header_for(account, initial_date, final_date)
      if portuguese_language?
        initial_date = date_to_s(initial_date)
        final_date = date_to_s(final_date)
        "Nome da Conta: #{account.banner} (de: #{initial_date}, até: #{final_date})"
      else
        "Account name: #{account.banner} (from: #{initial_date}, to: #{final_date})"
      end
    end

    def table_headings
      @table['headings']
    end

    def date_format
      @date_format['format']
    end

    def month_names
      @date_format['month_names']
    end

    def month_for(month)
      find_month_for month, month_names
    end

    def find_month_for(month, month_names)
      month_name = month_names.find { |month_name| month_name.equal?(month) }
      unless month_name
        raise MonthDontExist, "Month #{month} dont exist in locale: #{@name}. Availables months: #{month_names}"
      else
        month_names.index(month_name) + 1
      end
    end

    def available_locales
      [:pt, :en]
    end

    def create_alias_methods_for_pt
      @locale_methods.each do |klass, alias_pt_methods|
        eval("Financial::#{klass}").class_eval do
          alias_pt_methods.each do |pt_method, original_method_name|
            alias_method pt_method, original_method_name
          end
        end
      end
    end

    def add_per_cent_aliases
      Numeric.class_eval do
        alias_method :por_cento, :per_cent
      end
    end

    def name_of_the_parcel
      @names['parcel']
    end

    def balance_name
      @names['balance']
    end

    def deposit_name
      @names['deposit']
    end
    
    def received_deposit_name
      @names['received_deposit']
    end

    def coin
      @file['coin']
    end

    def create_alias_methods_for_en
      # skip
    end

    def ==(other_locale)
      name.equal?(other_locale.name)
    end

    def to_coin(value)
      "#{coin} #{format_coin(value)}"
    end

    def format_coin(value)
      %{#{sprintf("%.2f", value.to_s).gsub(period_separator, separator)}}
    end

    def portuguese_language?
      @name.equal? :pt
    end

    # I prefer to not use constants
    #
    def period_separator
      '.'
    end

    # I prefer to not use constants
    #
    def separator
      ','
    end
  end

  class LocaleDontAvailable < StandardError
  end

  class MonthDontExist < StandardError
  end
end