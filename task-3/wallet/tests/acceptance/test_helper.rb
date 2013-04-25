class Account
	def initialize(currency,value)
	end
end

class ExchangeRate
	def initialize(from_currency,to_currency,value)
	end
end

class StockPrice
	def initialize(name,price)
	end
end

class Exchanger
	def initialize(source_account,target_account,rate)
	end
end

class Stocker
	def initialize(stock_account,rate)
	end
end

class Supplier
	def initialize(currency,value)
	end
end

module WalletTestHelper
	def set_balance(accounts)
		@accounts ||= []
		accounts.each do |name,balance|
			@accounts << Account.new(name,balance)
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
	
	def find_account(currency)
		@accounts.find{|a| a.currency == account }
	end
	
	def find_rate(from_currency,to_currency)
		@rates.find{|r| r.from_currency == from_currency && r.to_currency == to_currency }
	end

	def sell_stock(name,amount)
		@amount ||= get_balance(:name)
		stocker = Stocker.new(find_account(name), find_stock_price(name))
		stocker.sell(amount)
	end

	def buy_stock(name,amount)
		stocker = Stocker.new(find_stock_price(name))
		stocker.buy(amount)
	end

	def supply_money(currency,amount)
		supplier = Supplier.new(find_account(:currency))
		supplier.supply(amount)
	end
end
