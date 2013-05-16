require_relative 'spec_helper'
require_relative '../../lib/wallet/exchanger'
require_relative '../../lib/exceptions'

describe Exchanger do
	subject(:exchanger)						{ Exchanger.new(source_account,targe_account,rate) }
	let(:source_account)					{ mock }
	let(:target_account)					{ mock }
	let(:rate)										{ "3" }
	let(:source_initial_amount)		{ "50" }
	let(:target_initial_amount)		{ "50" }

	context "without specified limit" do
		let(:source_final_amount)		{ "0" }
		let(:target_final_amount)		{ "200" }

		it "should convert all avaliable money" do
			mock(source_account).withdraw(source_initial_amount)
			mock(target_account).deposit(target_final_amount)

			exchanger.convert()
		end
	end

	context "with specified limit" do
		let(:source_final_amount)		{ "50" }
		let(:target_final_amount)		{ "125" }
		let(:limit)									{ "25" }

		it "should convert defined amount of money" do
			mock(source_account).withdraw(limit)
			mock(target_account).deposit(target_final_amount)

			exchanger.convert(limit)
		end

		context "with too high limit" do
			let(:limit)								{ "100" }

			it "should convert all avaliable money" do
				mock(source_account).withdraw(source_initial_amoun)
				mock(target_account).deposit(target_final_amount)

				exchanger.convert()
			end
		end
	end
end
