require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))
require 'filter'

describe Filter do
  
  range_2bit = [0, 18, 38, 59, 92]
  range_3bit = [0, 7, 18, 26, 38, 54, 59, 71, 92]
  
  before(:all) do
    @arr =    [86, 10, 49, 29, 26,  8,  0, 37, 54,  9,
               86, 29, 38, 59, 66, 56, 92,  5, 20, 18,
               66, 48, 55, 61, 20, 19,  7,  0, 36, 77,
               56, 26, 14, 61, 80,  1, 58, 71, 44, 49]
    
    @histogram =  {86=>2, 10=>1, 49=>2, 29=>2, 26=>2,
                          8=>1, 0=>2, 37=>1, 54=>1, 9=>1, 38=>1, 
                          59=>1, 66=>2, 56=>2, 92=>1, 5=>1, 20=>2, 
                          18=>1, 48=>1, 55=>1, 61=>2, 19=>1, 7=>1,
                          36=>1, 77=>1, 14=>1, 80=>1, 1=>1, 58=>1, 71=>1, 44=>1}    
        
    @cdf =  [[0, 2, 2], [1, 1, 3], [5, 1, 4],   [7, 1, 5],
             [8, 1, 6], [9, 1, 7], [10, 1, 8], [14, 1, 9],
             [18, 1, 10], [19, 1, 11], [20, 2, 13], [26, 2, 15],
             [29, 2, 17], [36, 1, 18], [37, 1, 19], [38, 1, 20],
             [44, 1, 21], [48, 1, 22], [49, 2, 24], [54, 1, 25],
             [55, 1, 26], [56, 2, 28], [58, 1, 29], [59, 1, 30],
             [61, 2, 32], [66, 2, 34], [71, 1, 35], [77, 1, 36],
             [80, 1, 37], [86, 2, 39], [92, 1, 40]]
    
    @filter_2bit = [3, 0, 2, 1, 1, 0, 0, 1, 2, 0,
                    3, 1, 1, 2, 3, 2, 3, 0, 1, 0,
                    3, 2, 2, 3, 1, 1, 0, 0, 1, 3,
                    2, 1, 0, 3, 3, 0, 2, 3, 2, 2]

    @filter_3bit = [7, 1, 4, 3, 2, 1, 0, 3, 4, 1,
                    7, 3, 3, 5, 6, 5, 7, 0, 2, 1,
                    6, 4, 5, 6, 2, 2, 0, 0, 3, 7,
                    5, 2, 1, 6, 7, 0, 5, 6, 4, 4]          
  end
  
  before(:each) do
    mock(@arr).to_histogram {@histogram}
    @filter = Filter.new(@arr)
  end
   
  it "should make CDF from given array" do
    @filter.arr.should == @cdf
  end
  
  it "should find ranges within 2 bits" do
    bits = 2
    ranges = @filter.find_ranges(bits)
    
    ranges.length.should == ((2 << (bits - 1)) + 1)
    ranges.should == range_2bit
  end
  
  it "should find ranges within 3 bits" do
    bits = 3
    ranges = @filter.find_ranges(bits)
    
    ranges.length.should == ((2 << (bits - 1)) + 1)
    ranges.should == range_3bit
  end
  
  it "should code values with given range - 2 bits" do
    bits = 2
    ranges = @filter.find_ranges(bits)
    ranges.should == range_2bit
    
    result = @filter.code_values(ranges)
    result.should == @filter_2bit
  end
  
  it "should code values with given range - 3 bits" do
    bits = 3
    ranges = @filter.find_ranges(bits)
    ranges.should == range_3bit
    
    result = @filter.code_values(ranges)
    result.should == @filter_3bit
  end
  
end