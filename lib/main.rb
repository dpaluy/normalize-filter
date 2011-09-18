$LOAD_PATH << File.expand_path(File.join('..', 'lib'), File.dirname(__FILE__))
require 'filter'
require 'action_maker'
require 'tools/progressbar'

#SETTINGS
RANGE_BITS = 2
PRICE_RANGE = 3
DEFAULT_FOLDER = 'input/'

def make_action(data, filename)
  am = ActionMaker.new(data)
  actions = am.find(PRICE_RANGE)
  
  File.open(DEFAULT_FOLDER + filename.sub(/.csv/, '.ac'),'w') do |f|
    actions.each_with_index do |v, i|
      f.print "#{v} "
      f.puts "" if ((i % 100) == 0) 
    end 
  end
end

def make_filter(data, filename)
  filter = Filter.new( data.map {|v| v[1].to_f} )
  ranges = filter.find_ranges(RANGE_BITS)
  l = filter.code_values(ranges)
  
  File.open(DEFAULT_FOLDER + filename.sub(/.csv/, '.l'),'w') do |f|
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
  data
end

def proceed(filename)
  #data input file
  data = load_file(filename)
  #L file
  make_filter(data, File.basename(filename))
  #Action file
  make_action(data, File.basename(filename))
end

##################
# MAIN
##################
if ARGV.length < 1
  puts "Usage: #{__FILE__} file/directory"
  exit
end

#Create default folder
Dir.mkdir(DEFAULT_FOLDER) unless File.exists?(DEFAULT_FOLDER)

if File.directory?(ARGV[0])
  dir = ARGV[0].chomp('/')
  path = "#{dir}/**/*.csv"
  filelist = Dir[path]
  pbar = ProgressBar.new("#{filelist.length} records", filelist.length)
  filelist.each do |f|
    proceed(f)
    pbar.inc
  end
  pbar.finish
else
  filename = ARGV[0]
  puts "Preparing #{filename}"
  proceed(filename)
  puts 'Done'
end

#Generate list of input files
path = "#{DEFAULT_FOLDER}*.l"
files = Dir[path]
File.open("#{DEFAULT_FOLDER}input.txt","w") do |list|
  list.puts files.length
  files.sort.each do |f|
    name = File.basename(f)
    list.puts "#{DEFAULT_FOLDER}#{name} #{DEFAULT_FOLDER}#{name.sub(/.l/, '.ac')}"
  end
end
