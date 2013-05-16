require_relative '../../lib/wallet'

module WalletTestHelper
	def set_balance(accounts)
		@accounts ||= []
		accounts.each do |currency,balance|
			@accounts << Account.new(currency,balance)
		end
	end


	def set_stock_balance(accounts)
		@accounts ||= []
		accounts.each do |name,amount|
			@accounts << Account.new(name,amount)
		end
	end
	
	def set_exchange_rate(rates)
		@rates ||= []
		rates.each do |(from_currency, to_curency), rate|
			@rates << ExchangeRate.new(from_currency,to_currency,rate)
		end
	end

	def set_stock_price(stock_price)
		@stock_price ||= []
		stock_price do |name, price|
			@stock_price << StockPrice.new(name, price)
		end
	end

	def convert_money(from_currency,to_currency,limit)
		@limit ||= get_balance(from_currency)
		exchanger = Exchanger.new(find_account(from_currency), find_account(to_currency), find_rate(from_currency, to_currency))
		exchanger.convert(limit)
	end

	def get_balance(currency)
		find_account(currency).balance
	end

	def get_stock_balance(name)
		find_account(name).balance
	end
	
	def find_account(currency)
		@accounts.find{|a| a.currency == account }
	end
	
	def find_rate(from_currency,to_currency)
		@rates.find{|r| r.from_currency == from_currency && r.to_currency == to_currency }
	end

	def sell_stock(name,amount)
		@amount ||= get_balance(name)
		stocker = Stocker.new(find_account(name), find_stock_price(name))
		stocker.sell(amount)
	end

	def buy_stock(name,amount)
		stocker = Stocker.new(find_stock_price(name))
		stocker.buy(amount)
	end

	def supply_money(currency,amount)
		supplier = Supplier.new(find_account(currency))
		supplier.supply(amount)
	end
end
