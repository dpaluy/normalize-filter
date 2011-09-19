$LOAD_PATH << File.expand_path(File.join('..', 'lib'), File.dirname(__FILE__))
require 'tools/array'
require 'tools/progressbar'

DEFAULT_OUTPUT_FOLDER = 'merged_input/'

def load_data_from_file(filename)
  data = []
  File.open(filename,'r') do |f|
    while (line = f.gets)
      line = line.strip
      unless line.empty?
        arr = line.split(' ').collect {|v| v.to_i}
        data.concat(arr)
      end
    end
  end
  data
end

def save_merged_data(data, filename)
  File.open(DEFAULT_OUTPUT_FOLDER + filename,'w') do |f|
    data.each_with_index do |v, i|
      f.print "#{v} "
      f.puts "" if ((i % 100) == 0)
    end
  end
end

def merge_files(filename1, filename2)
  f1 = File.basename(filename1)
  f2 = File.basename(filename2)
  d1 = f1[0..8]
  d2 = f2[0..8]
  raise "Wrong dates #{d1} #{d2}" if d1 != d2

  arr1 = load_data_from_file(filename1)
  arr2 = load_data_from_file(filename2)
  raise "Files: #{filename1} #{filename2} Wrong data #{arr1.length} #{arr2.length}" if arr1.length > arr2.length
  merged = []
  bits = 2 #TODO
  arr1.each_with_index do |v1, index|
    v2 = arr2[index]
    new_value = [v1, v2]
    merged << new_value.merge(bits)
  end

  asset1 = f1[8..-1].sub('.l', '')
  asset2 = f2[8..-1].sub('.l', '')
  save_merged_data(merged, "#{d1}_#{asset1}_#{asset2}.l")
end

##################
# MAIN
##################
if ARGV.length < 2
  puts "Usage: #{__FILE__} directory1 directory2 "
  exit
end

#Create default folder
Dir.mkdir(DEFAULT_OUTPUT_FOLDER) unless File.exists?(DEFAULT_OUTPUT_FOLDER)

dir1 = ARGV[0]
dir2 = ARGV[1]

if !File.directory?(dir1) || !File.directory?(dir2)
  puts 'Wrong directories'
  exit
end

path1 = "#{dir1.chomp('/')}/**/*.l"
filelist1 = Dir[path1].sort

path2 = "#{dir2.chomp('/')}/**/*.l"
filelist2 = Dir[path2].sort

if ARGV[2] == "--dry_run" || ARGV[2] == "-d"
  File.open("dry_run.txt","w") {|f|
    filelist1.each_with_index {|v, index|
      f.puts "#{v}, #{filelist2[index]}"
    }
  }
  exit
else
  pbar = ProgressBar.new("#{filelist1.length} records", filelist1.length)
  filelist1.each_with_index do |f, i|
    #merge
    merge_files f, filelist2[i]
    pbar.inc
  end
  pbar.finish
end
