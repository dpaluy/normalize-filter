# make Daily files from big csv file
require 'fileutils' 

if ARGV.length() < 1
  puts "Usage: " + __FILE__ + " filename.csv"
  exit
end

current_date = ""
infilename = ARGV[0]
dirname = infilename.gsub('.csv','')
if File.directory? dirname
  puts "The folder #{dirname} is already exists. Please delete/rename this folder before start!"
  exit
else
  FileUtils.mkdir dirname
end
outfile = nil
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
      outfilename = "#{infilename.gsub('.csv','')}/#{the_date.gsub('-','')}_#{params[0].gsub('.','')}.csv"
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
