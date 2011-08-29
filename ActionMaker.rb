require 'MinMax'
require 'tools/array'

class ActionMaker
  
  ### SETTINGS
  ########################################
  DELTA = 1
  PRICE_RANGE = 2
  NUMBER_OF_TICKS = 10
  ########################################
     
  def initialize(arr)
    grouped_values = make_grouped_array(arr)
    average_array = calc_average(grouped_values)
    actions = find_actions
    
    results = get_all_actions(actions, grouped_values, average_array)    
  end

private  
  
  def get_all_actions(actions, grouped_values, average_array)
    results = []
    actions.each_with_index do |action, i|
      current_group = grouped_values[i]
      if action == MinMax::ACTION_TYPE[:DO_NOTHING]
        results.concat(Array.new(current_group.length, MinMax::ACTION_TYPE[:DO_NOTHING]))
      else
        current_group.each do |v|
          if (v - average_array[i]).abs < DELTA
            results << action
          else
            results << MinMax::ACTION_TYPE[:DO_NOTHING]
          end
        end
      end
    end
    results
  end

  def make_grouped_array(arr)
    grouped_values = []
    slot = -1  
    arr.each_with_index do |v, i|
      if ((i % NUMBER_OF_TICKS) == 0)
        sub_group = []
        slot += 1
        grouped_values << sub_group
      end
      grouped_values[slot] << v
    end
    grouped_values
  end
  
  def calc_average(arr)
    average_array = []
    arr.each do |v|
      average_array << v.mean
    end
    average_array
  end
  
  def find_actions(average_array)
    mm = MinMax.new(average_array, PRICE_RANGE)
    mm.find
  end
  
  
end