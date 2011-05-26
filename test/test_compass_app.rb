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

    control = "body{-ms-filter:\"progid:DXImageTransform.Microsoft.Alpha(Opacity=50)\";filter:progid:DXImageTransform.Microsoft.Alpha(Opacity=50);opacity:0.5}\n"
    
    assert_equal control, last_response.body
  end
end
