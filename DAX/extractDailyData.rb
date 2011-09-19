# make Daily files from big csv file
require 'fileutils'
require 'time'

def extract_file(infilename)
  dirname = infilename.gsub('.csv','')
  if File.directory? dirname
    puts "The folder #{dirname} is already exists. Please delete/rename this folder before start!"
    exit
  else
    FileUtils.mkdir dirname
  end
  outfile = nil
  current_date = ""
  File.open(infilename,'r') do |infile|
    infile.gets # ignore first line
    while (line = infile.gets)
      # .GDAXI,02-JAN-2006,09:00:27.141,Index,5410.24
      params = line.strip.split(",")
      the_date = params[1]
      if (current_date != the_date)
        current_date = the_date
        if !outfile.nil?
          outfile.close
        end
        # open new file for writing
        d = Time.parse(the_date).strftime("%m%d%Y")
        outfilename = "#{infilename.gsub('.csv','')}/#{d}_#{params[0].gsub('.','')}.csv"
        outfile = File.open(outfilename,'w')
        puts "Open file: #{outfilename}"
      end
      # write line to the file
      outfile.puts "#{params[2]},#{params[4]}"
    end
  end

  if !outfile.nil?
    outfile.close
  end
end

if ARGV.length() < 1
  puts "Usage: " + __FILE__ + " filename/folder"
  exit
end

if File.directory?(ARGV[0])
  path = "#{ARGV[0].chomp('/')}/**/*.csv"
  filelist = Dir[path].sort
  filelist.each {|f| extract_file(f) }
else
  extract_file(ARGV[0])
end

