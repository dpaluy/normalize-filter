require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))
require 'general_filter'

describe GeneralFilter do
  
  before(:each) do
    @range_bits = 3
    @price_range = 2
    @default_output_folder = "input/"
    @filter = GeneralFilter.new(@range_bits, @price_range, @default_output_folder)
  end

  it "should load data from file and create L and Action files" do
    dummy_data = [["9:40", "12345"], ["9:41", "22.2"]]
    filename = "folder/temp.csv"
    mock(@filter).load_file(filename).returns(dummy_data)
    mock(@filter).make_hourly_filter(dummy_data, "temp.csv")
    
    separator = 'hourly'
    @filter.proceed(separator, filename, false)
  end
  
  it "should load data from given filename" do
    filename = "folder/temp.csv"
    #lines = "09:10,12345, 09:12,345.4"
    #arr = [["09:10", "12345"], ["09:12", "345.4"]]
    
    mock(File).open(filename, "r")
    mock(GroupArray)
    @filter.load_file(filename)
  end
  
  #TODO
end
