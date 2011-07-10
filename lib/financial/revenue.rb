module Financial
  class Revenue
    attr_accessor :name, :method_name, :value, :date
    def initialize(*args)
      args.flatten!
      @method_name = args.shift
      @name = @method_name.to_s.split('_').join(' ').capitalize
      @value = args.shift
      @date = Date.today
    end

    def tax(*args)
      return @tax if args.empty?
      @tax = Tax.new(@method_name, tax_value_for(args))
    end

    def in_date(date)
      @date = Financial::FinancialDate.new(date).date
      self
    end

    def format_value
      "+ #{Financial.locale.format_coin(value)}"
    end

    def is_a_received_deposit?(account)
      false
    end

    private
      def tax_value_for(args)
        tax_value = args.first
        if tax_value.is_a?(Hash)
          tax_value[:decreases]
        else
          value * args.first
        end
      end
  end
end