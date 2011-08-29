# make Daily files from big csv file
require 'fileutils' 

if ARGV.length() < 1
  puts "Usage: " + __FILE__ + " filename.csv"
  exit
end

current_date = ""
infilename = ARGV[0]
FileUtils.mkdir infilename.gsub('.csv','')
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
      outfilename = "#{infilename.gsub('.csv','')}/#{params[0].gsub('.','')}#{the_date.gsub('-','')}.csv"
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

#dir name
#Pathname.new(__FILE__).dirname # => "/home/allen/"