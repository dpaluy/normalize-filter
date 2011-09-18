require 'time'
require 'tools/array'

class GroupArray
  
  attr_reader :data #TODO
  
  def initialize(data)
    @data = data
  end
  
  def fill_missing_min(arr)
    result = []
    arr.each_with_index do |v, i|
      if v == arr.first 
        result << v
      else
        prev = arr[i-1]
        prev_time = Time.parse(prev[0])
        diff = ((Time.parse(v[0]) - prev_time) / 60).to_i - 1
        
        diff.times do 
          prev_time = (prev_time + 60) # add 60 sec
          new_value = [prev_time.strftime("%H:%M"), prev[1]]
          result << new_value
        end  
        result << v
      end
    end
    result
  end
  
  def get_every_min
    result = []
    grouped = (@data.group_by { |v| Time.parse(v[0]).strftime("%H:%M") }).sort
    grouped.each do |v|
      t = v[0]
      average_value = (v[1].map {|val| val[1].to_f}).mean.round(2) 
      grouped_value = [t, average_value]
      result << grouped_value
    end
    
    result
  end
  
end