require 'singleton'

module Financial
  class AccountManager
    include Singleton
    attr_accessor :accounts

    def initialize
      @accounts = []
    end

    def new_account(args)
      account = Account.new(args)
      @accounts.push(account)
      account
    end

    def find_account(account_name)
      if account_name == :all or account_name == :todas
        @accounts
      else
        @accounts.select { |a_account| a_account.name.equal?(account_name) }
      end
    end
  end
end