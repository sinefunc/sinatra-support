require File.expand_path('../helper', __FILE__)

class CssAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  class App < Sinatra::Base
    register Sinatra::CssSupport
    serve_css '/css', :from => File.expand_path('../fixtures/css', __FILE__)
  end

  def app
    App.new
  end

  test "sass" do
    get '/css/style-sass.css'

    assert_equal "body, #sass {\n  color: #333333; }\n", last_response.body
  end

  test "scss" do
    get '/css/style-scss.css'

    assert_equal "body, #scss {\n  color: #333333; }\n", last_response.body
  end

  test "less" do
    get '/css/style-less.css'

    assert_equal "body, #less { color: #333333; }\n", last_response.body
  end
end
