require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))
require 'tools/array'

describe Array do
  
  it "should merge array with 2 bits" do
    bits = 2
    arr = [1, 2, 3]
    arr.merge(bits).should == 57
  end
  
  it "should merge array with 3 bits" do
    bits = 3
    arr = [4, 3, 4]
    arr.merge(bits).should == 284
  end
  
end