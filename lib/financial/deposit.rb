module Financial
  class Deposit < Cost
    attr_accessor :name, :value
    attr_reader :account_to_deposit, :account_name

    def initialize(value, _account_name)
      @value = value
      @date = Date.today
      @account_to_deposit = :anonymous
      @account_name = _account_name
      deposit_name!
    end

    def in_account(account_name)
      @account_to_deposit = account_name
      deposit_name!
      self
    end

    def deposit_name!
      @name = "#{Financial.locale.deposit_name}: #{@account_to_deposit}"
    end

    # Return true if is a received deposit
    #
    def is_a_received_deposit?(account)
      (not account.deposits.include?(self)) and (account.name.equal?(account_to_deposit))
    end
  end
end