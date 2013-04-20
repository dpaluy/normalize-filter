module Enumerable

  def to_histogram
    inject(Hash.new(0)) { |h, x| h[x] += 1; h}
  end

  def cdf
    previous = 0
    self.each do |value|
      value[2] = value[1] + previous
      previous = value[2]
    end
  end
  
end
