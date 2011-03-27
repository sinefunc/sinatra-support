require 'rubygems'  unless RUBY_VERSION >= '1.9'
require 'test/unit'
require 'contest'
require 'ohm'
require 'haml'
require 'mocha'
require 'rack/test'
require 'nokogiri'
require 'sinatra'

$:.unshift File.expand_path('../../lib', __FILE__)
$:.unshift File.dirname(__FILE__)

require 'sinatra/support'

class Test::Unit::TestCase
  def settings
    @app ||= Sinatra::Application.new
  end

  def self.fixture_path(*a)
    root = File.expand_path('../fixtures', __FILE__)
    File.join root, a
  end

  def fixture_path(*a)
    self.class.fixture_path *a
  end
end
