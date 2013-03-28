require_relative 'spec_helper'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(db: database) }
  let(:database)            { stub }
	let(:item)                { Struct.new(:title,:description).new(title,description) }
  let(:title)               { "Shopping" }
  let(:description)         { "Go to the shop and buy toilet paper and toothbrush" }

  it "should raise an exception if the database layer is not provided" do
    expect{ TodoList.new(db: nil) }.to raise_error(IllegalArgument)
  end

  it "should be empty if there are no items in the DB" do
    stub(database).items_count { 0 }
    list.should be_empty
  end

  it "should not be empty if there are some items in the DB" do
    stub(database).items_count { 1 }
    list.should_not be_empty
  end

  it "should return its size" do
    stub(database).items_count { 6 }

    list.size.should == 6
  end

  it "should persist the added item" do
    mock(database).add_todo_item(item) { true }
    mock(database).get_todo_item(0) { item }

    list << item
    list.first.should == item
  end

  it "should persist the state of the item" do
    mock(database).get_todo_item(0) { item }
		
		mock(database).todo_item_completed?(0) { false }
    mock(database).complete_todo_item(0,true) { true }
    mock(database).todo_item_completed?(0) { true }
    mock(database).complete_todo_item(0,false) { true }

    list.toggle_state(0)
    
		mock(database).get_todo_item(0) { item }
		list.toggle_state(0)
  end

  it "should fetch the first item from the DB" do
    mock(database).get_todo_item(0) { item }
    list.first.should == item

    mock(database).get_todo_item(0) { nil }
    list.first.should == nil
  end

  it "should fetch the last item from the DB" do
    stub(database).items_count { 6 }

    mock(database).get_todo_item(5) { item }
    list.last.should == item

    mock(database).get_todo_item(5) { nil }
    list.last.should == nil
  end

  it "should return nil for the first and the last item if the db is empty" do
    stub(database).items_count { 0 }

    mock(database).get_todo_item(0) { nil } 
    list.first.should == nil
    list.last.should == nil
  end

	context "with empty title of the item" do
    let(:title)   { "" }

    it "should not add the item to the DB" do
      dont_allow(database).add_todo_item(item)

      list << item
    end
  end
	
	context "with nil item" do
		let(:item) { nil }
		

		it "should raise an exception when changing the item state if the item is nil" do
			mock(database).get_todo_item(0) { item }
			
			expect{ list.toggle_state(0)}.to raise_error(IllegalArgument)
		end

		it "should not accept a nil item" do
			dont_allow(database).add_todo_item(item)
			
			list << item
		end
	end

	context "with too short title" do
		let(:title) { "A"}

		it "should not accept an item with too short (but not empty) title" do
			dont_allow(database).add_todo_item(item)

			list << item
		end
	end
	
  context "with missing description" do
		let(:description) {}
			
		it "should accept an item with missing description" do
			mock(database).add_todo_item(item) { true } 
			list << item
		end
	end

	context "with social network" do
		subject(:list)					{ TodoList.new(db: database, social_network: network) }
		let(:network)						{ stub! }
		let(:add_prefix)				{ "I am going to " }
		let(:complete_suffix)		{ " is done" }

	  it "should notify social network if an item is added to the list" do
			mock(database).add_todo_item(item) { true }
			mock(network).spam("[" + title + "] " + add_prefix + description) { true }
			list << item
		end

		it "should notify social network if an item is completed" do
			mock(network).spam("[" + title + "] " + description + complete_suffix) { true }
			
			mock(database).get_todo_item(0) { item }
			mock(database).todo_item_completed?(0) { false }
			mock(database).complete_todo_item(0, true)
			
			list.toggle_state(0)
		end
		
		context "with missing title" do
			let(:title) { "" } 

			it "should not notify social network if the title od the item is missing" do
				dont_allow(network).spam
				list << item
			end
		end

		context "with missing description" do
			let(:description) { "" }

			it "should notify social network if the body of the item is missing" do
				mock(database).add_todo_item(item) { true }
				mock(network).spam("[" + title + "] missing description") { true }
				list << item
			end
		end

		context "with too long title" do
			let(:title) { "q"*256 }

			it "should cut the title of the item when notifying social network about added item if it is longer than 255 chars" do
				mock(database).add_todo_item(item) { true }
				mock(network).spam("[" + title[0...255] + "] " + add_prefix + description) { true }
				list << item
			end

			it "should cut thetitle of the item when notifying social network about completed item if it is longer than 255 chars" do
				mock(network).spam("[" + title[0...255] + "] " + description + complete_suffix) { true }

				mock(database).get_todo_item(0) { item }
				mock(database).todo_item_completed?(0) { false }
				mock(database).complete_todo_item(0, true)

				list.toggle_state(0)
			end
		end
	end
end
