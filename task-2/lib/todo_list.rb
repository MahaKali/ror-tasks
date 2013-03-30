class TodoList

	# Initialize the TodoList with +items+ (empty by default).
	def initialize(items=nil)
		raise IllegalArgument if items[:db] == nil
      
		@database = items[:db]
		@network = items[:social_network]
	end

	def empty?()
		@database.items_count == 0
	end
 
	def size()
		@database.items_count
	end 

	def <<(item)
		return nil if item == nil || item[:title] == "" ||	item[:title].size < 3
		
		short_title = cut_title(item)
		@database.add_todo_item(item)

		if @network
			suffix = "] I am going to " + item[:description]
			suffix = "] missing description" if item[:description].nil? || item[:description].empty?
			title = "[" + short_title 
				 
			@network.spam(title + suffix)
		end
	end

	def first()
		first = @database.get_todo_item(0)
		return nil if first == nil
		first
	end

	def last()
		return nil if self.size <= 0
		@database.get_todo_item(self.size - 1)
	end

	def toggle_state(index)
		item = @database.get_todo_item(index)

		raise IllegalArgument if item == nil
		short_title = cut_title(item)
			
		@database.todo_item_completed?(index) ? @database.complete_todo_item(index, false) : @database.complete_todo_item(index, true)
   	@network.spam("[" + short_title + "] " + item[:description] + " is done") if @network
	end
	
	protected 
	
	def cut_title(item)
		return item[:title][0...255]
	end
end
