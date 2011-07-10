Feature: Financial Portuguese dsl
  In order to wrtie my code in portuguese
  As a user
  I want to write my dsl in portuguese to use the dates and stuff in pt

 Scenario: Print with deposits in the same day and different days and receive deposits too
   Given a file named "example.rb" with:
   """
   # coding: utf-8
   lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
   $LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

   require 'financial'
   Financial.locale = :pt
   include Financial::DSL

   conta :minha_conta do
     total 1000.5

     depositos do
       deposite(100.5).na_conta(:outra_conta).na_data('13/7/2011')
	   deposite(400).na_conta(:conta_do_sobrinho).in_date('13/7/2011')
     end

     faturamento do
       salario(100).na_data('6/7/2011')
       design_site(300).na_data('8/7/2011')
     end

     custos do
       cartao_de_credito(150).na_data('6/7/2011')
       notebook(250).in_date('9/7/2011')
     end
   end

   conta :outra_conta do
     total -100
   end

   imprima_conta :todas do
     de('3/6/2011').até('16/7/2011')
   end

   """
   When I run `ruby example.rb`
   Then the stdout should contain exactly:
   """
Nome da Conta: Minha conta (de: 03/06/2011, até: 16/07/2011)
+------------+-----------------------------+-----------+------------+
| Data       | Nome                        | Valor(R$) | Total      |
+------------+-----------------------------+-----------+------------+
| 03/06/2011 | Saldo Inicial               | --------  | R$ 1000,50 |
+------------+-----------------------------+-----------+------------+
| 06/07/2011 | Cartao de credito           | - 150,00  |            |
|            | Salario                     | + 100,00  |            |
+------------+-----------------------------+-----------+------------+
|            | Saldo                       | --------  | 950,50     |
+------------+-----------------------------+-----------+------------+
| 08/07/2011 | Design site                 | + 300,00  |            |
+------------+-----------------------------+-----------+------------+
|            | Saldo                       | --------  | 1250,50    |
+------------+-----------------------------+-----------+------------+
| 09/07/2011 | Notebook                    | - 250,00  |            |
+------------+-----------------------------+-----------+------------+
|            | Saldo                       | --------  | 1000,50    |
+------------+-----------------------------+-----------+------------+
| 13/07/2011 | Deposito: outra_conta       | - 100,50  |            |
|            | Deposito: conta_do_sobrinho | - 400,00  |            |
+------------+-----------------------------+-----------+------------+
|            | Saldo                       | --------  | 500,00     |
+------------+-----------------------------+-----------+------------+
+------------+-----------------------------+-----------+------------+
| 16/07/2011 | Saldo Final                 | --------  | R$ 500,00  |
+------------+-----------------------------+-----------+------------+

Nome da Conta: Outra conta (de: 03/06/2011, até: 16/07/2011)
+------------+--------------------------------+-----------+------------+
| Data       | Nome                           | Valor(R$) | Total      |
+------------+--------------------------------+-----------+------------+
| 03/06/2011 | Saldo Inicial                  | --------  | R$ -100,00 |
+------------+--------------------------------+-----------+------------+
| 13/07/2011 | Deposito recebido: minha_conta | + 100,50  |            |
+------------+--------------------------------+-----------+------------+
|            | Saldo                          | --------  | 0,50       |
+------------+--------------------------------+-----------+------------+
+------------+--------------------------------+-----------+------------+
| 16/07/2011 | Saldo Final                    | --------  | R$ 0,50    |
+------------+--------------------------------+-----------+------------+


   """

 
