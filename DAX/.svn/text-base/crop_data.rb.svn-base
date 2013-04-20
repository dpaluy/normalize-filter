require 'time'

def crop_file(filename)
  start_time = Time.parse("10:00") 
  last_line_cmd = "tail -1 #{filename}"
  value = %x[ #{last_line_cmd} ]
  if value.index("Error:")
    puts value
    raise "Error #{filename}" 
  else   
    if value[0, 2] == "14"
      end_time = Time.parse("14:01")
    else
      end_time   = Time.parse("17:31")
    end
  end 
  
  end_time_last_day_of_the_year = Time.parse("14:00")  
  File.open(filename,'r') do |inf|
    File.open("#{filename}.tmp","w") do |outf|
      while (line = inf.gets)
        val = line.split(',')
        t = Time.parse(val[0])
        if t >= start_time && t < end_time
          outf.puts line
        end
      end
    end
  end
  
  cmd = "mv #{filename}.tmp #{filename}"
  value = %x[ #{cmd} ]
  puts "#{filename} cropped"
end

if ARGV.length() < 1
  puts "Usage: " + __FILE__ + " filename/folder"
  exit
end

if File.directory?(ARGV[0])
  path = "#{ARGV[0].chomp('/')}/**/*.csv"
  filelist = Dir[path].sort
  filelist.each_with_index {|f, i| puts "#{i}/#{filelist.length}"; crop_file(f) }
else
  crop_file(ARGV[0])
end