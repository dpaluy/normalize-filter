require 'tools/enumerable'

class Filter
  
  attr_accessor :arr
  
  def initialize(arr)
    @arr = arr.to_histogram.sort
    @arr.cdf
  end
 
  def find_ranges(bits)
    intervals = 2 << (bits - 1)
    maximum = @arr.last[2] # maximum
    limit = range_size = maximum / intervals
    
    ranges_arr = []
    ranges_arr << @arr.first[0] # minimum
    
    while limit < maximum do
      high_value = @arr.min {|a,b| (a[2] - limit).abs <=> (b[2] - limit).abs }
      ranges_arr << high_value[0]
      limit += range_size
    end
    
    ranges_arr << @arr.last[0] # maximum
    
    #ranges = ranges_arr.each_cons(2).map{|left, right| Range.new(left, right)}
  end

end