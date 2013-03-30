class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    if items == nil
      raise IllegalArgument
    else
      @items = items
      @status = {}
      @items.each do | item |
        @status[item] = false
      end
    end
  end

  def size()
    @items.size
  end

  def empty?()
    @items.empty?
  end

  def <<(item)
    @items << item
    @status[item] = false
  end
  
  def last()
    @items.last
  end 

  def first()
    @items.first
  end

  def completed?(index)
    @status[@items[index]]
  end

  def complete(index)
    @status[@items[index]] = true
  end

  def not_complete(index)
    @status[@items[index]] = false
  end

  def return_completed()
    returned = []
    @items.each do | item |
      if @status[item]
        returned << item
      end
    end
    returned
  end
  
  def return_uncompleted()
    returned = []
    @items.each do | item |
    	if @status[item] == false
      	returned << item
    	end
    end
    returned
  end

  def remove_item(index)
		a = @items[index]
    @items.delete_at(index)
		@status.delete(a)
  end

  def remove_completed()
		@items.delete_if { |item| @status[item] == true }	
  end      
  
  def switch_items(first = nil, second = nil)
    if first == nil && second == nil
      items = []

      while @items.empty?
        items.first = @items.shift
      end
      @items = items
    else
      @items[first], @items[second] = @items[second], @items[first]
    end
  end

  def sort()
    @items.sort!()
  end

  def reset()
    @items = []
    @status = {}
  end

  def toggle_state(index)
    @status[@items[index]] ? @status[@items[index]] = false : @status[@items[index]] = true
	end

  def [] (index)
    @items[index]
  end

  def []= (index,item)
    @items[index] = item
  end
  
  def convert()
		converted = ""
    @items.each do | item |
      converted += @status[item] ? "- [x] " + item.to_s + "\n" : "- [ ] " + item.to_s + "\n" 
    end
		converted[0..-2]
  end
end
