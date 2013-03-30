require 'bundler/setup'
require 'rspec/expectations'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(items) }
  let(:items)               { [] }
  let(:item_description)    { "Buy toilet paper" }

  it { should be_empty }

  it "should raise an exception when nil is passed to the constructor" do
    expect { TodoList.new(nil) }.to raise_error(IllegalArgument)
  end

  it "should have size of 0" do
    list.size.should == 0
  end

  it "should accept an item" do
    list << item_description
    list.should_not be_empty
  end

  it "should add the item to the end" do
    list << item_description
    list.last.to_s.should == item_description
  end

  it "should have the added item uncompleted" do
    list << item_description
    list.completed?(0).should be_false
  end

  context "with one item" do
    let(:items)             { [item_description] }

    it { should_not be_empty }

    it "should have size of 1" do
      list.size.should == 1
    end

    it "should have the first and the last item the same" do
      list.first.to_s.should == list.last.to_s
    end

    it "should not have the first item completed" do
      list.completed?(0).should be_false
    end

    it "should change the state of a completed item" do
      list.complete(0)
      list.completed?(0).should be_true
    end
  end
  
  context "with items" do
    before:each do
      list.reset
      list << "Example 1"
      list << "Example 2"
      list << "An Example 3"
      list << "Example 4"
      list.complete(2)
      list.complete(3)
    end

		it { should_not be_empty }

    it "should have size more than 1" do
      list.size.should > 1
    end

    it "should return completed items" do
      returned_list = list.return_completed
      returned_list.should == ["An Example 3", "Example 4"] 
    end

    it "should return uncompleted items" do
      returned_list = list.return_uncompleted
      returned_list.should == ["Example 1", "Example 2"]
    end

    it "should remove an individual item" do
      list.remove_item(0)
      list.first.should == "Example 2"
    end

    it "should remove all completed items" do
      returned_list = list.remove_completed
      returned_list.should == ["Example 1", "Example 2"]
    end

    it "should revert order of two items" do
      list.switch_items(0,1)
      list.first.should == "Example 2"
    end

    it "should revert order of all items" do
      list.switch_items
    end

    it "should toggle the state of an item" do
      list.completed?(0).should == false
      list.toggle_state(0)
      list.completed?(0).should == true
      list.toggle_state(0)
      list.completed?(0).should == false
    end

    it "should settle the state of the item to uncompleted" do
      list.not_complete(2)
      list.completed?(2).should == false
    end

    it "should change the description of an item" do
      list[3] = "Example 123"
      list[3].should == "Example 123"
    end

    it "should sort the items by name" do
      sorted = list.sort
      sorted.should == ["An Example 3","Example 1", "Example 2", "Example 4"]
    end

    it "should convert the list to text" do
      list.convert.should ==  "- [ ] " + list[0] + "\n- [ ] " + list[1] + "\n- [x] " + list[2] + "\n- [x] " + list[3] 
    end
  end
end
