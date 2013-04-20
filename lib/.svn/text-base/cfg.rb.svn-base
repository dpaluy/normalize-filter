# gem install parseconfig
require 'parseconfig'

class Cfg

  CONFIG_NAME = 'filter.cfg'

  def initialize(name = nil)
    begin
      @c = ParseConfig.new(name || CONFIG_NAME)
    rescue Errno::ENOENT
      puts "The config file you specified was not found"
      #exit
    rescue Errno::EACCES
      puts "The config file you specified is not readable"
      #exit
    end
  end

  def params(p=nil)
    if p.nil?
      @c.get_params
    elsif p[:group].nil?
      @c.params[p[:param]]
    else
      @c.params[p[:group]][p[:param]]
    end
  end

  def groups
    @c.get_groups
  end
end

