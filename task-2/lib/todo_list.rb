class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=nil)
    if items[:db] == nil
      raise IllegalArgument
    else
      @database = items[:db]
			@network = items[:social_network]
		end
  end

  def empty?()
    @database.items_count == 0
  end
 
  def size()
    @database.items_count
  end 

  def <<(other_object)
    if other_object == nil or other_object[:title] == "" or	other_object[:title].size < 3
			nil
		else
			# other_object[:title] = other_object[:title][0...255]
      cut_title(other_object)
			
			@database.add_todo_item(other_object)
			if @network
				if other_object[:description] == ""
					@network.spam("[" + other_object[:title] + "] missing description")
				else
					@network.spam("[" + other_object[:title] + "] I am going to " + other_object[:description])
				end
			end
		end
  end

	def first()
		if @database == nil
			nil
		else
    	@database.get_todo_item(0)
		end
  end

  def last()
    if self.size > 0
      @database.get_todo_item(self.size - 1)
    else
      nil
    end
  end

  def toggle_state(index)
		item = @database.get_todo_item(index)
		if item == nil
			raise IllegalArgument
		else
			# item[:title] = item[:title][0...255]
			cut_title(item)
			
			@database.todo_item_completed?(index) ? @database.complete_todo_item(index, false) : @database.complete_todo_item(index, true)
   		@network.spam("[" + item[:title] + "] " + item[:description] + " is done") if @network
	  end
	end
	
	def cut_title(item)
		item[:title] = item[:title][0...255]
	end
end
