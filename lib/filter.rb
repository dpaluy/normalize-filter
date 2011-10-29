require 'tools/enumerable'

#calculate L
class Filter

  attr_accessor :arr
  
  def initialize(arr)
    @arr = arr.to_histogram.sort
    @arr.cdf
  end

  def find_ranges(bits)
    intervals = 2 << (bits - 1)   
    maximum = @arr.last[2] # maximum
    limit = range_size = maximum / intervals.to_f
     
    ranges_arr = []
    ranges_arr << @arr.first[0] # minimum

    while limit < maximum do
      high_value = @arr.min {|a,b| (a[2] - limit).abs <=> (b[2] - limit).abs }
      ranges_arr << high_value[0]
      limit += range_size
    end

    ranges_arr << @arr.last[0] # maximum
  end

  def code_values(ranges, values)
    result = []
    values.each do |value|
      if (value >= ranges.max)
        index = ranges.length - 2
      else
        index = 1
        until (value <= ranges[index]) do
          index += 1
        end
        index -= 1
      end
      result << index
    end
    
    result
  end

end
