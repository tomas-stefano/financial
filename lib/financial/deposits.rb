module Financial
  class Deposits < Array
    attr_reader :account_name
    def initialize(account_name)
      @account_name = account_name
      super()
    end

    def deposit(value)
      deposit = Deposit.new(value, @account_name)
      self.push(deposit)
      deposit
    end
  end
end