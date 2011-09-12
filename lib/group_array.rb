require 'time'
require 'tools/array'

class GroupArray
  
  def initialize(data)
    @data = data
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