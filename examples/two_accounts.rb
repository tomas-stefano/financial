lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'financial'
include Financial::DSL

account :my_bank_account do
  total 1000.5

  deposits do
    deposit(100.5).in_account(:other_bank_account).in_date('7/13/2011')
    deposit(400).in_account(:inexistent_account).in_date('7/13/2011')
  end

  revenues do
    salary(100).in_date('7/06/2011')
    design_site(300).in_date('7/8/2011')
  end

  costs do
    credit_card(150).in_date('7/06/2011')
    notebook(250).in_date('7/9/2011')
  end
end

account :other_bank_account do
  total -100
end

print_account :all do
  from('06/03/2011').to('07/16/2011')
end
