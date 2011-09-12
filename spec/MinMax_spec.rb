require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))
require 'MinMax' # for lib/MinMax.rb

ACTION_TYPE = { :NA => 0, :BUY => 1, :SELL => 2 }
     
describe MinMax, "having array of sorted values," do
  
  #[[-8, 7], [2, 6], [2, 11], [3, 1], [5, 0], [6, 3], [7, 4], [10, 2], [10, 8], [10, 9], [11, 5], [14, 10]]
  ARR =     [5, 3, 10, 6, 7, 11, 2, -8, 10, 10, 14, 2]
  ACTIONS = [1, 1,  2, 1, 0,  2, 1,  1,  2,  2,  2, 0]
  RANGE = 2

  SMALL_ACTIONS = [ ACTION_TYPE[:BUY], ACTION_TYPE[:SELL], ACTION_TYPE[:NA]]
  SMALL_ARR = [5, 10, 2]
    
  def init_big_array
    @minmax = MinMax.new ARR, RANGE
  end

  def init_small_array
    @minmax = MinMax.new SMALL_ARR, RANGE
  end
  
  it "should find 2 max values index 6" do
    init_big_array
    index = 6
    result = @minmax.get_max_from_list(index)
    result.should == [14, 10]
    
    result = @minmax.get_max_from_list(index)
    result.should == [10, 8]
  end
  
  it "should find max subarray after index 11" do
    init_big_array
    index = 11
    result = @minmax.get_max_from_list(index)
    result.should be_nil 
  end
    
  it "should find BUY, SELL set within a range in small array" do
    init_small_array
    result = @minmax.find
    result.should == SMALL_ACTIONS
  end

  it "should find BUY, SELL set within a range in big array" do
    init_big_array
    result = @minmax.find
    result.should == ACTIONS
  end

end
