require 'group_array'
require 'min_max'

class ActionMaker
     
  attr_reader :values
  
  def initialize(data)
    grouped_array = GroupArray.new(data).get_every_min
    @values = grouped_array.map {|v| v[1]}
  end

  def find(price_range)
    MinMax.new(@values, price_range).find
  end
   
end