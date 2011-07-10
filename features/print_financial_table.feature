Feature: Print Financial Table
  In order to know all information of all my finances
  As a user
  I want to know all dates for my costs and revenues to see my profit!

 @announce
 Scenario: Print an empty account
   Given a file named "example.rb" with:
   """
   lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
   $LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

   require 'financial'
   include Financial::DSL

   account :my_bank_account do
     total 100
   end

   print_account :all do
     from('06/03/2011').to('07/16/2011')
   end

   """
   When I run `ruby example.rb`
   Then the stdout should contain exactly:
   """
Account name: My bank account (from: 2011-06-03, to: 2011-07-16)
+------------+-----------------+----------+----------+
| Date       | Name            | Value($) | Total    |
+------------+-----------------+----------+----------+
| 06/03/2011 | Initial Balance | -------- | $ 100,00 |
+------------+-----------------+----------+----------+
+------------+-----------------+----------+----------+
| 07/16/2011 | Final Balance   | -------- | $ 100,00 |
+------------+-----------------+----------+----------+


   """
 
 @announce
 Scenario: Print with costs
   Given a file named "example.rb" with:
   """
   lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
   $LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

   require 'financial'
   include Financial::DSL

   account :my_bank_account do
     total 100

     costs do
       credit_card(110).in_date '7/06/2011'
     end
   end

   print_account :all do
     from('06/03/2011').to('07/16/2011')
   end

   """
   When I run `ruby example.rb`
   Then the stdout should contain exactly:
   """
Account name: My bank account (from: 2011-06-03, to: 2011-07-16)
+------------+-----------------+----------+----------+
| Date       | Name            | Value($) | Total    |
+------------+-----------------+----------+----------+
| 06/03/2011 | Initial Balance | -------- | $ 100,00 |
+------------+-----------------+----------+----------+
| 07/06/2011 | Credit card     | - 110,00 |          |
+------------+-----------------+----------+----------+
|            | Balance         | -------- | -10,00   |
+------------+-----------------+----------+----------+
+------------+-----------------+----------+----------+
| 07/16/2011 | Final Balance   | -------- | $ -10,00 |
+------------+-----------------+----------+----------+


   """
 
 @announce
 Scenario: Print with revenues
   Given a file named "example.rb" with:
   """
   lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
   $LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

   require 'financial'
   include Financial::DSL

   account :my_bank_account do
     total 100

     revenues do
       salary(110).in_date('7/06/2011')
     end
   end

   print_account :all do
     from('06/03/2011').to('07/16/2011')
   end

   """
   When I run `ruby example.rb`
   Then the stdout should contain exactly:
   """
Account name: My bank account (from: 2011-06-03, to: 2011-07-16)
+------------+-----------------+----------+----------+
| Date       | Name            | Value($) | Total    |
+------------+-----------------+----------+----------+
| 06/03/2011 | Initial Balance | -------- | $ 100,00 |
+------------+-----------------+----------+----------+
| 07/06/2011 | Salary          | + 110,00 |          |
+------------+-----------------+----------+----------+
|            | Balance         | -------- | 210,00   |
+------------+-----------------+----------+----------+
+------------+-----------------+----------+----------+
| 07/16/2011 | Final Balance   | -------- | $ 210,00 |
+------------+-----------------+----------+----------+


   """
 
 @announce
 Scenario: Print with revenues and costs in the same day
   Given a file named "example.rb" with:
   """
   lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
   $LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

   require 'financial'
   include Financial::DSL

   account :my_bank_account do
     total 100

     revenues do
       salary(110).in_date('7/06/2011')
     end

     costs do
       credit_card(180).in_date('7/06/2011')
     end
   end

   print_account :all do
     from('06/03/2011').to('07/16/2011')
   end

   """
   When I run `ruby example.rb`
   Then the stdout should contain exactly:
   """
Account name: My bank account (from: 2011-06-03, to: 2011-07-16)
+------------+-----------------+----------+----------+
| Date       | Name            | Value($) | Total    |
+------------+-----------------+----------+----------+
| 06/03/2011 | Initial Balance | -------- | $ 100,00 |
+------------+-----------------+----------+----------+
| 07/06/2011 | Credit card     | - 180,00 |          |
|            | Salary          | + 110,00 |          |
+------------+-----------------+----------+----------+
|            | Balance         | -------- | 30,00    |
+------------+-----------------+----------+----------+
+------------+-----------------+----------+----------+
| 07/16/2011 | Final Balance   | -------- | $ 30,00  |
+------------+-----------------+----------+----------+


   """
 
 @announce
 Scenario: Print with revenues and costs in the same day and different days
   Given a file named "example.rb" with:
   """
   lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
   $LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

   require 'financial'
   include Financial::DSL

   account :my_bank_account do
     total 1000.5

     revenues do
       salary(100).in_date('7/06/2011')
       design_site(300).in_date('7/8/2011')
     end

     costs do
       credit_card(150).in_date('7/06/2011')
       notebook(250).in_date('7/9/2011')
     end
   end

   print_account :all do
     from('06/03/2011').to('07/16/2011')
   end

   """
   When I run `ruby example.rb`
   Then the stdout should contain exactly:
   """
Account name: My bank account (from: 2011-06-03, to: 2011-07-16)
+------------+-----------------+----------+-----------+
| Date       | Name            | Value($) | Total     |
+------------+-----------------+----------+-----------+
| 06/03/2011 | Initial Balance | -------- | $ 1000,50 |
+------------+-----------------+----------+-----------+
| 07/06/2011 | Credit card     | - 150,00 |           |
|            | Salary          | + 100,00 |           |
+------------+-----------------+----------+-----------+
|            | Balance         | -------- | 950,50    |
+------------+-----------------+----------+-----------+
| 07/08/2011 | Design site     | + 300,00 |           |
+------------+-----------------+----------+-----------+
|            | Balance         | -------- | 1250,50   |
+------------+-----------------+----------+-----------+
| 07/09/2011 | Notebook        | - 250,00 |           |
+------------+-----------------+----------+-----------+
|            | Balance         | -------- | 1000,50   |
+------------+-----------------+----------+-----------+
+------------+-----------------+----------+-----------+
| 07/16/2011 | Final Balance   | -------- | $ 1000,50 |
+------------+-----------------+----------+-----------+


   """

 @announce
 Scenario: Print with deposits in the same day and different days and receive deposits too
   Given a file named "example.rb" with:
   """
   lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
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

   """
   When I run `ruby example.rb`
   Then the stdout should contain exactly:
   """
Account name: My bank account (from: 2011-06-03, to: 2011-07-16)
+------------+-----------------------------+----------+-----------+
| Date       | Name                        | Value($) | Total     |
+------------+-----------------------------+----------+-----------+
| 06/03/2011 | Initial Balance             | -------- | $ 1000,50 |
+------------+-----------------------------+----------+-----------+
| 07/06/2011 | Credit card                 | - 150,00 |           |
|            | Salary                      | + 100,00 |           |
+------------+-----------------------------+----------+-----------+
|            | Balance                     | -------- | 950,50    |
+------------+-----------------------------+----------+-----------+
| 07/08/2011 | Design site                 | + 300,00 |           |
+------------+-----------------------------+----------+-----------+
|            | Balance                     | -------- | 1250,50   |
+------------+-----------------------------+----------+-----------+
| 07/09/2011 | Notebook                    | - 250,00 |           |
+------------+-----------------------------+----------+-----------+
|            | Balance                     | -------- | 1000,50   |
+------------+-----------------------------+----------+-----------+
| 07/13/2011 | Deposit: other_bank_account | - 100,50 |           |
|            | Deposit: inexistent_account | - 400,00 |           |
+------------+-----------------------------+----------+-----------+
|            | Balance                     | -------- | 500,00    |
+------------+-----------------------------+----------+-----------+
+------------+-----------------------------+----------+-----------+
| 07/16/2011 | Final Balance               | -------- | $ 500,00  |
+------------+-----------------------------+----------+-----------+

Account name: Other bank account (from: 2011-06-03, to: 2011-07-16)
+------------+-------------------------------+----------+-----------+
| Date       | Name                          | Value($) | Total     |
+------------+-------------------------------+----------+-----------+
| 06/03/2011 | Initial Balance               | -------- | $ -100,00 |
+------------+-------------------------------+----------+-----------+
| 07/13/2011 | Deposit from: my_bank_account | + 100,50 |           |
+------------+-------------------------------+----------+-----------+
|            | Balance                       | -------- | 0,50      |
+------------+-------------------------------+----------+-----------+
+------------+-------------------------------+----------+-----------+
| 07/16/2011 | Final Balance                 | -------- | $ 0,50    |
+------------+-------------------------------+----------+-----------+


   """

