require File.expand_path('../helper', __FILE__)

class AppModuleTest < Test::Unit::TestCase
  module MyModule
    include Sinatra::AppModule

    module MyHelpers
      def apple(); "Apple"; end
    end

    helpers MyHelpers

    helpers do
      def banana(); "Banana"; end
    end

    get('/') { "Hello" }
    get('/apple') { apple }
    get('/banana') { banana }

    configure do
      set :skittles, "rainbow"
    end

    set :saturn, 'big'
  end

  class App < Sinatra::Base
    include MyModule
  end

  include Rack::Test::Methods
  def app() App; end

  test "hello" do
    get '/'
    assert last_response.body == "Hello"
  end

  test "helpers in a module" do
    get '/apple'
    assert last_response.body == 'Apple'
  end

  test "helpers" do
    get '/banana'
    assert last_response.body == 'Banana'
  end

  test "configure block" do
    assert App.skittles == 'rainbow'
  end

  test "set" do
    assert App.saturn == 'big'
  end
end
