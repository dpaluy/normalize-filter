class MinMax
  
  attr_accessor :list
  
  ACTION_TYPE = {
   :DO_NOTHING => 0, :BUY => 1, :SELL => 2
  }
  
  ### arr - array of price values sorted by time stamps
  def initialize(arr, price_range)
    @list = arr.each_with_index.map {|v, i| [v, i] }.sort 
    @price_range = price_range
  end
  
  def get_max_from_list ( limit )
    # TODO: Review
    sub_array = @list.find_all {|v| v[1] > limit}
    max = sub_array.max_by(&:first)
    @list.delete max unless max.nil?
    max
  end
  
  def find
    actions = Array.new(@list.length, ACTION_TYPE[:DO_NOTHING])
    begin
      min = @list.shift
      limit = min[1]
      max = get_max_from_list limit

      if (!min.nil? && !max.nil? && 
          (min[1] < max[1]) && ((max[0] - min[0])> @price_range) )
        actions[min[1]] = ACTION_TYPE[:BUY]
        actions[max[1]] = ACTION_TYPE[:SELL]
      end
    end while @list.size > 1
    actions
  end

end