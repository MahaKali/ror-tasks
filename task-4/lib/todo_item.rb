require 'active_record'

class TodoItem < ActiveRecord::Base
	belongs_to :todo_list

	validates :title, :presence => true, :length => { :in => 5..30 }
	validates :todo_list_id, :presence => true
	validates :description, :length => { :maximum => 255 }
end
