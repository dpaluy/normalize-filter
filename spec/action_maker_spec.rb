require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))
require 'action_maker'
require 'group_array'
require 'yaml'
  
describe ActionMaker, "having array of time ordered values," do
  describe "return a list of actions, according to default settings" do 
     
    before(:all) do
      @ACTION_TYPE = { :DO_NOTHING => 0, :BUY => 1, :SELL => 2 }
      @DATA = YAML::load File.open(File.expand_path(File.join('.', 'data.yml'), File.dirname(__FILE__)))
      @GROUPED_VALUES = [5411.59, 5410.72, 5415.3, 5415.92, 5414.73]
      @EXPECTED_ACTIONS_RANGE_1 = [
            @ACTION_TYPE[:BUY], @ACTION_TYPE[:BUY], 
            @ACTION_TYPE[:SELL], @ACTION_TYPE[:SELL], @ACTION_TYPE[:DO_NOTHING]
              ]  
    end
    
    before(:each) do    
      grouped_data = GroupArray.new(@DATA).get_every_min
      @action_maker = ActionMaker.new(grouped_data)
    end
    
    it "should group values by minutes and average" do
      @action_maker.values.should == @GROUPED_VALUES
    end
    
    it "should find all Min/Max and return list of actions - price_range 1" do
      actions = @action_maker.find(1)
      actions.should == @EXPECTED_ACTIONS_RANGE_1
    end
    
    it "should find all Min/Max and return zero actions - price_range 6" do
      actions = @action_maker.find(6)
      actions.should == Array.new(@GROUPED_VALUES.length, @ACTION_TYPE[:DO_NOTHING])
    end
    
  end
end