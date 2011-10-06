$LOAD_PATH << File.expand_path(File.join('..', 'lib'), File.dirname(__FILE__))
require 'general_filter'
require 'tools/progressbar'

#SETTINGS
RANGE_BITS = 2
PRICE_RANGE = 0.2
DEFAULT_FOLDER = 'input/'

##################
# MAIN
##################
if ARGV.length < 1
  puts "Usage: #{__FILE__} file/directory"
  exit
end

#Create default folder
Dir.mkdir(DEFAULT_FOLDER) unless File.exists?(DEFAULT_FOLDER)
DEFAULT_OUTPUT_FOLDER = "#{DEFAULT_FOLDER}#{File.basename(ARGV[0])}/"
Dir.mkdir(DEFAULT_OUTPUT_FOLDER) unless File.exists?(DEFAULT_OUTPUT_FOLDER)

if File.directory?(ARGV[0])
  dir = ARGV[0].chomp('/')
  path = "#{dir}/**/*.csv"
  filelist = Dir[path]
  thread_list = []
  filelist.each_slice(10) {|v| thread_list << v}
  pbar = ProgressBar.new("#{filelist.length} records", thread_list.length)
  
  thread_list.each do |list|
    t_arr = []
    list.each do |f|
      t_arr << Thread.new{
        main_filter = GeneralFilter.new(RANGE_BITS,PRICE_RANGE, DEFAULT_OUTPUT_FOLDER)
        main_filter.proceed(f)
      }
    end
    t_arr.each {|t| t.join }
    pbar.inc
  end  
  pbar.finish
else
  filename = ARGV[0]
  puts "Preparing #{filename}"
  GeneralFilter.new(RANGE_BITS,PRICE_RANGE, DEFAULT_OUTPUT_FOLDER).proceed(filename)
  puts 'Done'
end

#Generate list of input files
path = "#{DEFAULT_OUTPUT_FOLDER}*.l"
files = Dir[path]
File.open("#{DEFAULT_OUTPUT_FOLDER}input.txt","w") do |list|
  list.puts files.length
  files.sort.each do |f|
    name = File.basename(f)
    list.puts "#{DEFAULT_OUTPUT_FOLDER}#{name} #{DEFAULT_OUTPUT_FOLDER}#{name.sub(/.l/, '.ac')}"
  end
end
