class Array
  
  def sum 
    inject( nil ) { |sum,x| sum ? sum+x : x }
  end

  def mean 
    sum.to_f / size.to_f
  end

end