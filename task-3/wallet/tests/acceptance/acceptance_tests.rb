require_relative 'test_helper'

describe "virtual wallet" do
	include WalletTestHelper

	before.each do
	  set_balance :pln => 100
		set_stock_balance :f01 => 15
	end

	specify "supplying money in defined currency" do
		supply_money(:usd, 50)
		get_balance(:usd).should == 50
		get_balance(:pln).should == 100
	end

	specify "exchanging from USD to PLN with defined value" do
		set_balance :usd => 50
		set_exchange_rate [:usd, :pln] => 3.16
		convert_money(:usd,:pln,25)
		get_balance(:usd).should == 25
		get_balance(:pln).should == 179
	end

	specify "exchanging from USD to PLN without value" do
		set_balance :usd => 50
		set_exchange_rate [:usd, :pln] => 3.00
		convert_money(:usd,:pln)
		get_balance(:usd).should == 0
		get_balance(:pln).should == 250
	end

	specify "buying stock" do
		set_stock_rate :f02 => 3
		buy_stock(:f02, 10)
		get_stock_balance(:f01).should == 15
		get_stock_balance(:f02).should == 10
		get_balance(:pln).should == 70
	end

	specify "selling stock" do
		set_stock_rate :f01 => 5
		sell_stock(:f01,5)
		get_stock_balance(:f01).should == 10
		get_balance(:pln).should == 125
	end

	specify "demanding transfering money back to bank account" do
		transfer_money(:pln, 25)
		get_balance(:pln).should == 75
	end

	context "with not enough resources" do
		specify "exchanging money from USD to PLN" do
			set_balance :usd => 100
			set_exchange_rate [:usd, :pln] => 3.16 
			convert_money(:usd,:pln,150)
			get_balance(:usd).should == 0
			get_balance(:pln).should == 416
		end

		specify "buying stock" do
			set_stock_rate :f02 => 30
			buy_stock(:f02,5)
			get_stock_balance(:f02).should == 3
			get_balance(:pln).should == 10
		end

		specify "selling stock" do
			set_stock_rate :f01 => 5
			sell_stock(:f01,20)
			get_stock_balance(:f01).should == 0
			get_balance(:pln).should == 175
		end
	end 
end
