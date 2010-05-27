require 'rubygems'
require 'test/unit'
require 'contest'
require 'mocha'
require 'rack/test'
require 'nokogiri'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra/helpers'

class Test::Unit::TestCase
end
