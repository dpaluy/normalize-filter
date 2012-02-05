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
        value, time = line.split(',')
        data << [value.to_i, time]
      end
    end
  end
  data
end

def save_merged_data(data, filename)
  File.open(DEFAULT_OUTPUT_FOLDER + filename,'w') do |f|
    data.each_with_index do |v, i|
      f.puts "#{v[0]},#{v[1]} "
    end
  end
end

def copy_action(filename, folder)
  cmd = "cp #{filename} #{folder}"
  value = %x[ #{cmd} ]
end

def merge_files(filename1, filename2)
  f1 = File.basename(filename1)
  f2 = File.basename(filename2)
  d1 = f1[0..7]
  d2 = f2[0..7]
  raise "Wrong dates #{d1} #{d2}" if d1 != d2

  arr1 = load_data_from_file(filename1)
  arr2 = load_data_from_file(filename2)
  raise "Files: #{filename1} #{filename2} Wrong data #{arr1.length} #{arr2.length}" if arr1.length > arr2.length
  merged = []
  bits = 2 #TODO
  arr1.each_with_index do |v1, index|
    v2 = arr2[index]
    new_value = [v1[0], v2[0]]
    raise "Files: #{filename1} #{filename2} Wrong timestamps #{v1[1]} vs  #{v2[1]}" if v1[1] != v2[1]
    merged << [new_value.merge(bits), v1[1]]
  end

  asset1 = f1[9..-1].sub('.l', '')
  asset2 = f2[9..-1].sub('.l', '')
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
      f1 = File.basename(v)
      f2 = (index < filelist2.length)? File.basename(filelist2[index]): "no file"
      d1 = f1[0..8]
      d2 = f2[0..8]
      f.puts "#{v}, #{filelist2[index]}"
      exit if (d1 != d2)
    }
  }
  exit
else
  pbar = ProgressBar.new("#{filelist1.length} records", filelist1.length)
  date1 = filelist1.map {|f| File.basename(f)[0..8]}
  date2 = filelist2.map {|f| File.basename(f)[0..8]}
  filelist1.each_with_index do |f, i|
    f2_index = date2.index(date1[i])
    next if f2_index.nil?
    
    #merge
    merge_files f, filelist2[f2_index]
    copy_action f.sub(/.l/, '.ac'), DEFAULT_OUTPUT_FOLDER
    pbar.inc
  end
  pbar.finish

  #Generate list of input files
  path1 = "#{DEFAULT_OUTPUT_FOLDER}/*.l"
  merged_list_l = Dir[path1].sort

  path2 = "#{DEFAULT_OUTPUT_FOLDER}/*.ac"
  merged_list_ac = Dir[path2].sort

  File.open("#{DEFAULT_OUTPUT_FOLDER}input.txt", 'w') do |log|
    log.puts merged_list_l.length
    merged_list_l.each_with_index do |v, index|
      f1 = File.basename(v)
      f2 = (index < merged_list_ac.length)? File.basename(merged_list_ac[index]): "no file"
      log.puts "input/#{f1} input/#{f2}"
    end
  end

end
