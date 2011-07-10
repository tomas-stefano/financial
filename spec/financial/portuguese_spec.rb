require 'spec_helper'

Financial.locale = :pt
include Financial::PerCent

conta :uma_conta_de_banco do
  total -500
end

conta :banco_com_dinheiro do
  total 4000

  depositos do
    deposite(500).na_conta(:uma_conta_de_banco).na_data('27/07/2011')
  end

  custos do
    proxima_fatura(1000).na_data('26/07/2011')
    parcelas(6).de(316).todo_dia(19)
    parcelas(12).de(67).todo_dia(05).comecando_no_mes_de(:setembro)
  end

  faturamento do
    nota_fiscal(2500).na_data('02/07/2011').imposto(6.por_cento).na_data('17/07/2011')
  end
end

describe 'account :banco_com_dinheiro' do
  let(:banco_com_dinheiro) { Financial::Account.find(:name => :banco_com_dinheiro) }
  let(:uma_conta_de_banco) { Financial::Account.find(:name => :uma_conta_de_banco)}

  before do
    stub_date(1, 7, 2011)
  end

  describe '#name' do
    it 'should have :banco_com_dinheiro as a name' do
      banco_com_dinheiro.name.should equal :banco_com_dinheiro
    end
  end

  describe '#total' do
    it 'should have a total' do
      banco_com_dinheiro.total.should equal 4000
    end

    it 'should store negative totals too' do
      uma_conta_de_banco.total.should be -500
    end
  end

  describe '#costs' do
    it 'should have many costs counting taxes' do
      banco_com_dinheiro.costs.should have(19).items
    end

    it 'all costs should be instance of Costs' do
      banco_com_dinheiro.costs.all? { |cost|
        cost.instance_of?(Financial::Cost)
      }.should be_true
    end
  end

  describe '#total_costs' do
    it 'should calculate the total costs' do
      banco_com_dinheiro.total_costs.should == 4350 # costs + deposits + taxes
    end
  end

  describe '#revenues' do
    it 'should have some revenues' do
      banco_com_dinheiro.revenues.should have(1).item
    end
  end

  describe '#deposits' do
    it 'should have some deposits' do
      banco_com_dinheiro.deposits.should have(1).item
    end
  end

  describe '#total_revenues' do
    it 'should calculate the total revenues' do
      banco_com_dinheiro.total_revenues.should equal 2500
    end
  end

  describe '#taxes' do
    it 'should have some taxes' do
      banco_com_dinheiro.taxes.should have(1).item
    end
  end

  describe '#calculate_balances' do
    before do
      banco_com_dinheiro.calculate_balances
    end

    it 'should include balance in the date 02/07/2011' do
      Financial.locale = :pt
      Financial.locale.name.should be :pt
      banco_com_dinheiro.balances.should include_balance(6500).in_date('02/07/2011')
    end

    it 'should include one balance for :uma_conta_de_banco' do
      uma_conta_de_banco.balances.should have(1).items
    end

    it 'should include the recevied deposit from :banco_com_dinheiro' do
      uma_conta_de_banco.balances.should include_balance(0).in_date('27/07/2011')
    end

    it 'should have many balances' do
      banco_com_dinheiro.balances.should have(22).items
    end
  end
end