require_relative 'test_helper'
require_relative '../lib/todo_item'

describe TodoItem do 
	include TestHelper

	subject(:todo_item)			{ TodoItem.new(:title => title, :todo_list_id => todo_list_id, :description => description, :date_due => date_due) }
	let(:title)							{ "Shopping" }
	let(:todo_list_id)			{ 2 }
	let(:description)				{ "Buy flowers and peanut butter" }
	let(:date_due)					{ "2013-06-22" }
	
	it { should be_valid }
	
	context "with empty title" do
		let(:title)						{ "" }
		it { should_not be_valid }
	end

	context "with too short title" do
		let(:title)						{ "1234" }
		it { should_not be_valid }
	end

	context "with too long title" do
		let(:title)						{ "a"*31 }
		it { should_not be_valid }
	end

	context "with empty list it belongs to" do
		let(:todo_list_id)		{ nil }
		it { should_not be_valid }
	end	

	context "with empty description" do
		let(:description)			{ "" }
		it { should be_valid }
	end

	context "with too long description" do
		let(:description)			{ "a"*256 }
		it { should_not be_valid }
	end
end
