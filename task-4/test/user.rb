require_relative 'test_helper'
require_relative '../lib/user'

describe User do
	include TestHelper

	subject(:user) 							{ User.new(attributes) }
	let(:attributes) 						{{ :name => name,:surname => surname,:email => email,:terms_of_the_service => terms_of_the_service,:password => password,:password_confirmation => password_confirmation,:failed_login_count => failed_login_count }}
	let(:name)									{ "Jan" }
	let(:surname)								{ "Nowak" }
	let(:email)									{ "jan@nowak.pl" }
	let(:terms_of_the_service)	{ "1" }
	let(:password)							{ "janeknowak123" }
	let(:password_confirmation)	{ "janeknowak123" }
	let(:failed_login_count)		{ 0 }


	it { should be_valid }

	context "with empty name" do
		let(:name)			{ "" }
		it { should_not be_valid }
	end

	context "with too long name" do
		let(:name)			{ "b"*21 }
		it { should_not be_valid }
	end

	context "with empty surname" do
		let(:surname)		{ "" }
		it { should_not be_valid }
	end
	
	context "with too long surname" do
		let(:surname)		{ "g"*31 }
		it { should_not be_valid }
	end

	context "with invalid e-mail" do
		let(:email)			{ "jan.nowak.pl" }
		it { should_not be_valid }
	end

	context "with unaccepted terms of service" do
		let(:terms_of_the_service)	{ "0" }
		it { should_not be_valid }
	end

	context "with empty password" do
		let(:password)	{ "" }
		it { should_not be_valid }
	end

	context "with too short password" do
		let(:password)	{ "janek123" }
		it { should_not be_valid }
	end

	context "with empty password confirmation" do
		let(:password_confirmation)	{ "" }
		it { should_not be_valid }
	end

	context "with wrong password confirmation" do
		let(:password_confirmation)	{ "janek123" }
		it { should_not be_valid }
	end

	context "with empty failed_login_count" do
		let(:failed_login_count)	{ "" }
		it { should_not be_valid }
	end

	context "with non ingteger failed_login_count" do
		let(:failed_login_count)	{ 1.5 }
		it { should_not be_valid }
	end
end
