require 'filter'
require 'action_maker'
require 'group_array'

class MainFilter

  def initialize(range_bits, price_range, default_output_folder)
    @range_bits = range_bits
    @price_range = price_range
    @default_output_folder = default_output_folder
  end
  
  def make_action(data, filename)
    am = ActionMaker.new(data)
    actions = am.find(@price_range)
    
    File.open(@default_output_folder + filename.sub(/.csv/, '.ac'),'w') do |f|
      actions.each_with_index do |v, i|
        f.print "#{v} "
        f.puts "" if ((i % 100) == 0) 
      end 
    end
  end
  
  def make_filter(data, filename)
    filter = Filter.new( data.map {|v| v[1].to_f} )
    ranges = filter.find_ranges(@range_bits)
    l = filter.code_values(ranges)
    
    File.open(@default_output_folder + filename.sub(/.csv/, '.l'),'w') do |f|
      l.each_with_index do |v, i|
        f.print "#{v} "
        f.puts "" if ((i % 100) == 0)
      end
    end
  end
  
  def load_file(filename)
    data = []
    File.open(filename,'r') do |f|
      while (line = f.gets)
        time, value = line.strip.split(',') unless line.empty?
        data << [time, value]
      end
    end
    grouped_array = GroupArray.new(data).get_every_min
  end
  
  def proceed(filename)
    #data input file
    group = GroupArray.new(load_file(filename))
    grouped_data = group.get_every_min
    data = group.fill_missing_min(grouped_data)
    #L file
    make_filter(data, File.basename(filename))
    #Action file
    make_action(data, File.basename(filename))
  end
  
end