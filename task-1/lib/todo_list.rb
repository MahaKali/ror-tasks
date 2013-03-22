class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    if items == nil
      raise IllegalArgument
    else
      @items = items
      @status = {}
			@status,keys
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

  def <<(other_object)
    @items << other_object
    @status[other_object] = false
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
    @items.delete(index)
  end

  def remove_completed()
    list_to_remove = []
    @items.each do | item |
      if @status[item] == true
        list_to_remove << item
        # @items.delete(item)
      end
    end
    list_to_remove.each do | item |
      @items.delete(item)
    end
    p @items
  end      
  
  def switch_items(first = nil, second = nil)
    if first == nil && second == nil
      items = []
      while @items.empty?
        items.first = @items.shift
      end
      @items = items
    else
      tmp = @items[first]
      @items[first] = @items[second]
      @items[second] = tmp
    end
  end

  def sort()
    @items.sort!()
  end

  def new()
    @items = []
    @status = {}
  end

  def toogle_state(index)
    p @status[@items[index]]
    @status[@items[index]] ? @status[@items[index]] = false : 
@status[@items[index]] = true
  end

  def [] (index)
    @items[index]
  end

  def []= (index,other_object)
    @items[index] = other_object
  end
  
  def convert()
    @items.each do | item |
      print @status[item] ? "- [x] " + item.to_s + "\n" : "- [ ] " + item.to_s + "\n" 
    end

  end

end
