module Financial
  class Parcels < Cost
    attr_accessor :number, :name
    attr_reader :value_of_the_parcels, :day_of_the_parcels, :beginning_month, :month_number

    def initialize(number_of_parcels)
      @name = Financial.locale.name_of_the_parcel
      @number = number_of_parcels
      @day_of_the_parcels = 1
      @value_of_the_parcels = 0
      @beginning_month = Date.today.month
    end

    def of(value)
      @value_of_the_parcels = value
      self
    end

    def every_day(day)
      @day_of_the_parcels = day
      self
    end

    def beginning(month)
      @beginning_month = Financial.locale.month_for(month)
      self
    end

    def to_cost
      @today = Date.today
      number.times.collect do |parcel_number|
        day = @day_of_the_parcels
        month = choose_month_for(parcel_number)
        year  = choose_year_for(:parcel_number => parcel_number)
        date = Financial.locale.right_date_format(day, month, year)
        Cost.new(@name, @value_of_the_parcels).in_date(date)
      end
    end

    def day_of_the_parcel_is_in_this_month?
      @day_of_the_parcels >= @today.day
    end

    # TODO: Change this procedural code :\
    #
    def choose_month_for(parcel_number)
      months = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      index = @beginning_month - 1 + parcel_number
      if index >= 12
        months[index - 12]
      else
        months[index]
      end
    end

    # TODO: Change this procedural code :\
    #
    def choose_year_for(options)
      parcel_number = options[:parcel_number]
      @current_year = current_date.year
      @month_number = @beginning_month + parcel_number
      if @month_number >= 12
        find_year_for_parcel
      else
        @current_year
      end
    end

    def value
      @value_of_the_parcels * @number
    end

    private
      def find_year_for_parcel
        sum = 0
        while (@month_number > 12) do
          @month_number = @month_number - 12
          sum += 1
        end
        @current_year + sum
      end

      def current_date
        Date.today
      end
  end
end