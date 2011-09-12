require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))
require 'ActionMaker'

describe ActionMaker, "having array of time ordered values," do
  describe "return a list of actions, according to default settings" do
    
    ARR = [5, 3, 10, 6, 7, 11, 2, -8, 10, 10, 14, 2] 
    
    before(:each) do
      @action_maker = ActionMaker.new(ARR)
    end
    
    it "should group values by minutes and average" do
      time_ordered_values
      
    end
    
  end
end