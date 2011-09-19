if ARGV.length < 1
  puts "Usage: #{__FILE__} directory"
  exit
end

path = "#{ARGV[0].chomp('/')}/*"
list = Dir[path]
list.each do |l|
  if File.directory?(l)
    name = File.basename(l)
    if name.length == 7
      numbers = name[3..-1]
      mm = numbers[0..1]
      yy = numbers[2..-1]
      if (mm != "20")
        new = l.sub(numbers, "20#{yy}_#{mm}")
        File.rename(l,new)
      end
    end
    
  end
end
