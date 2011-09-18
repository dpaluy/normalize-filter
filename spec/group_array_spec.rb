require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))
require 'group_array'
require 'yaml'

describe GroupArray, "with time ordered two dimmension array" do
  
  AVERAGE = [['09:00', 5411.59], ['09:01', 5410.72], ['09:02', 5415.30],
             ['09:03', 5415.92], ['09:07', 5414.73]]

  FILLED_AVERAGE = [['09:00', 5411.59], ['09:01', 5410.72], ['09:02', 5415.30],
                    ['09:03', 5415.92], ['09:04', 5415.92], ['09:05', 5415.92],
                    ['09:06', 5415.92], ['09:07', 5414.73]]                
                                            
  before(:each) do
    DATA = YAML::load File.open(File.expand_path(File.join('.', 'data.yml'), File.dirname(__FILE__)))
    @group_array = GroupArray.new(DATA)
  end
  
  it "should return grouped array with average values" do
    result = @group_array.get_every_min
    result.length.should ==  AVERAGE.length
    result.should == AVERAGE
  end

  it "should fill missing minutes upon request" do
    grouped_result = @group_array.get_every_min
    filled_arr = @group_array.fill_missing_min(grouped_result)
    filled_arr.should == FILLED_AVERAGE 
  end
end
