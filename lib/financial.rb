require "financial/version"
require 'date'
require 'forwardable'
require 'terminal-table'
require 'yaml'

module Financial
  autoload 'Account', 'financial/account'
  autoload 'AccountManager', 'financial/account_manager'
  autoload 'Balance', 'financial/balance'
  autoload 'BalanceCalculation', 'financial/balance_calculation'
  autoload 'Cost', 'financial/cost'
  autoload 'Costs', 'financial/costs'
  autoload 'Deposit', 'financial/deposit'
  autoload 'Deposits', 'financial/deposits'
  autoload 'DSL', 'financial/dsl'
  autoload 'FinancialDate', 'financial/financial_date'
  autoload 'Locale', 'financial/locale'
  autoload 'Parcels', 'financial/parcels'
  autoload 'PerCent', 'financial/per_cent'
  autoload 'PrintTable', 'financial/print_table'
  autoload 'Revenue', 'financial/revenue'
  autoload 'Revenues', 'financial/revenues'
  autoload 'RSpecMatchers', 'financial/rspec_matchers'
  autoload 'FinancialTable', 'financial/financial_table'
  autoload 'Tax', 'financial/tax'

  def self.locale=(locale_name)
    @locale = Locale.new(locale_name)
  end

  def self.locale
    @locale || Locale.new(:en)
  end

  def self.account_manager
    AccountManager.instance
  end
end