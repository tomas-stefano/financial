module Financial
  module RSpecMatchers
    def self.included(base)
      create_include_balance_matcher
    end

    def create_include_balance_matcher
      RSpec::Matchers.define :include_balance do |expected|
        chain :in_date do |date|
          @date = Financial::FinancialDate.new(date).date
        end

        failure_message_for_should do |actual|
          if @date
            "expected #{actual} to have balance #{expected} in date #{@date}"
          else
            "expected #{actual} to have balance #{expected}"
          end
        end

        match do |actual|
          actual.should_not be_empty
          if @date
            actual.any? { |balance| balance.date == @date and balance.value == expected }
          else
            actual.any? { |balance| balance.value == expected }
          end
        end
      end
    end
  end
end