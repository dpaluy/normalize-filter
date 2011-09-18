require 'min_max'

class ActionMaker
     
  attr_reader :values
  
  def initialize(data)
    @values = data.map {|v| v[1]}
  end

  def find(price_range)
    MinMax.new(@values, price_range).find
  end
   
end