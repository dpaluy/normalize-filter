# encoding: utf-8

require "rubygems"
require 'test/unit'
require "rspec"
require 'simplecov'
require 'rr'

$LOAD_PATH << File.expand_path(File.join('..', 'lib'), File.dirname(__FILE__))
  
RSpec.configure do |config|
  # == Mock Framework
  config.mock_with :rr
end

SimpleCov.start