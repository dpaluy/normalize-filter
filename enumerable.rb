module Enumerable
  
  def to_histogram
    inject(Hash.new(0)) { |h, x| h[x] += 1; h}
  end
  
end
