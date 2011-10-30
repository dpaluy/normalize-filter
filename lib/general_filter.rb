require 'filter'
require 'action_maker'
require 'group_array'

class GeneralFilter

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
  
  def calc_l(ranged_data, values)
    filter = Filter.new( ranged_data.map{|v| v[1].to_f} )
    ranges = filter.find_ranges(@range_bits)
    l = filter.code_values(ranges, values.map{|v| v[1].to_f})
  end
  
  ###
  # ranged_data - data to build histogram
  # values - action values
  def separate_data_by_time(data, separator)
    times = data.map {|v| Time.parse(v[0]).strftime("%H:%M")}
    index = times.index(Time.parse(separator).strftime("%H:%M"))
    raise "Error separating time" if (index.nil?)
    
    ranged_data = data[0..index-1]
    values = data[index..-1]    
    return ranged_data, values
  end
  
  def make_filter(ranged_data, values, filename)
    l = calc_l(ranged_data, values)
    
    File.open(@default_output_folder + filename.sub(/.csv/, '.l'),'w') do |f|
      l.each_with_index do |v, i|
        f.print "#{v} "
        f.puts "" if ((i % 100) == 0)
      end
    end
  end
  
  def make_hourly_filter(data, filename)
    l = []
    start = 0
    values = data[start, 60]
    
    loop = (data.length / 60.to_f).ceil
    loop.times do
      start =+ 60
      ranged_data = values  
      values = data[start, 60]
      l << calc_l(ranged_data, values)
    end

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
    grouped_array = GroupArray.new(data)
    grouped_data = grouped_array.get_every_min 
    grouped_array.fill_missing_min(grouped_data) # TODO: rewrite it
  end
  
  def proceed(separator, filename, action=true)
    #data input file
    data = load_file(filename)
    
    if (separator == 'hourly')
      #L file
      make_hourly_filter(data, File.basename(filename))
      #Action file
      make_action(data[60..-1], File.basename(filename)) if action
    else
      ranged_data, values = separate_data_by_time(data, separator)
      #L file
      make_filter(ranged_data, values, File.basename(filename))
      #Action file
      make_action(values, File.basename(filename)) if action
    end
  end
  
end
