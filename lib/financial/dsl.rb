module Financial
  module DSL
    def account(*args, &block)
      account = Financial.account_manager.new_account(args)
      account.instance_eval(&block)
      account
    end

    def print_account(name, &block)
      print_table = PrintTable.new(name)
      print_table.instance_eval(&block)
      print_table.print!
      print_table
    end
  end
end