require File.expand_path('../helper', __FILE__)

Encoding.default_external = 'utf-8'

class CompassAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  class App < Sinatra::Base
    set :scss, { :style => :compressed }
    register Sinatra::CompassSupport
    get('/style.css') { scss "@import 'compass/css3'; body { @include opacity(0.5); }" }
  end

  def app
    App.new
  end

  test "boogie" do
    get '/style.css'

    assert_includes last_response.body, 'filter:'
  end
end
