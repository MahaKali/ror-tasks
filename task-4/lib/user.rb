require 'active_record'

class User < ActiveRecord::Base
	has_many :todo_lists
	has_many :todo_items, :through => :todo_lists
	
	validates :name, 				:presence => true, 
													:length => { :maximum => 20 }
	validates :surname, 		:presence => true, 
													:length => { :maximum => 30 }
	validates :email, 			:presence => true,
													:uniqueness => true, 
													:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/ }
	validates :terms_of_the_service, :acceptance => true
	validates :password, :presence => true, 
													:length => { :minimum => 10 }, 
													:confirmation => true
	validates :password_confirmation, :presence => true
	validates :failed_login_count, :numericality => { :only_integer => true }
end
