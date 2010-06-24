require 'rubygems'
require 'test/unit'
require 'contest'
require 'mocha'
require 'rack/test'
require 'nokogiri'
require 'ohm'
require 'haml'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra/support'

class Test::Unit::TestCase
end
