Financial
=========

* A simple way to organize your money and costs, dates.
  Is just a table information to you know the exactly money you will have in your account.

<div style="padding:2px; border:1px solid silver; float:right; margin:0 0 1em 2em; background:white">
  <img src="https://github.com/tomas-stefano/financial/raw/master/duck_tales.gif" alt="Duck Tales" />
</div>

Why?
----

* Solve my problems. Maybe this will solve yours problems.

Install
-------

    gem install financial

Usage
-----

    require 'financial'

    include Financial::DSL
	include Financial::PerCent

    account :my_bank_account do
      total 10 # current total

      costs do
        a_cost(400).in_date('7/30/2011')
        other_cost(500).in_date('7/31/2011')
        other_other_cost(100) # will use current date if dont pass a date option
        credit_card(1000)
      end

	  revenues do   # or  billing do
	    a_revenue(300).tax(200).in_date('09/20/2011')  # the profit here will be 100 and the date of the a_revenue will be today and the tax date will be '09/20/2011'
	    other_revenue(500).in_date('07/15/2011').tax(6.per_cent).in_date('08/20/2011')
	    bill(2000).tax(12.per_cent)
	    developing_the_site_y 1000
	    developing_the_other_site 900
	  end

    end

**Obs**: 

  * **You can pass ANY NAME in the #revenues block and #costs block**
 	because is used **method_missing** feature.
  * The **tax** method is a **cost** that will be a **multiplication**, 
	and the profit will be calculate like the following: 500 * 0.06 == Profit! :)
  * If you wanna **subtract** the revenue use the **tax(:decreases => 200)** option, 
	and the profit will be calculate like that: 10 - 200

Print information in the terminal
---------------------------------

And to print the information of bank account:
	
    print_financial_account :my_bank_account do
      period :from => current_date, :to => '07/16/2011'
    end

Work with more than one bank account
------------------------------------

	account :other_bank do
	  total 30

	  deposits do
	    deposit(500).in_account(:my_bank_account) # The bank account above!
	  end
	  
	  costs do
	    some_cost(500).in_date('07/20/2011')
	  end
	end

**OBS.:**

   * You can deposit in yours accounts objects or in accounts that don't exist
   * If you deposit in a existent accountant then will decreases from this account and increase in that account that exists.

If you just like to get/find the object of bank account just do:

    other_bank_account = Financial::Account.where :account => :other_bank

:)

Print information of all accounts
---------------------------------

Just pass **:all** option:

    print_financial_account :all do
      period(current_date).to('07/16/2011')
    end

More Examples
-------------

See [examples folder](https://github.com/tomas-stefano/financial/tree/master/examples)

Portuguese
----------

Is possible to have a portuguese DSL with dates, and the language itself.

	Then:

	    require 'financial'

		Financial.locale = :pt
		include Financial::DSL
		include Financial::PerCent

	    conta :minha_conta do
	      total 215.0

	      depositos do
	        deposite(500).na_conta(:outra_conta).na_data('20/07/2011') # will add 500 in outra_conta in the 20 July 2011
	      end

	      despesas do
	        contador 100
	      end

	      faturamento do
	    	nota_fiscal(1000).na_data('25/07/2011').imposto(6.por_cento)
	      end
	    end

		# imprima_conta :minha_conta do
		#  periodo(data_corrente).até('16/07/2011')
		# end

		imprima_conta :todos do
		  periodo(data_atual).até('16/07/2011')
		end

	   # imprima_conta :todos do
	   #   periodo('20/06/2011').até('16/07/2011')
	   # end
		
		

OUTPUT EXAMPLE
--------------

This is an output example from [two_accounts.rb](https://github.com/tomas-stefano/financial/blob/master/examples/two_accounts.rb)

<div style="padding:2px; border:1px solid silver; float:right; margin:0 0 1em 2em; background:white">
  <img src="https://github.com/tomas-stefano/financial/raw/master/example.png" alt="Output Example" />
</div>
