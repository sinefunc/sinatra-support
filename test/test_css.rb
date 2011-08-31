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

  def assert_css(css)
    left  = last_response.body.gsub(/[ \r\n\t]+/m, '')
    right = css.gsub(/[ \r\n\t]+/m, '')

    assert_equal left, right

  end
  test "sass" do
    get '/css/style-sass.css'

    assert_css "body, #sass {\n  color: #333333; }\n"
  end

  test "scss" do
    get '/css/style-scss.css'

    assert_css "body, #scss {\n  color: #333333; }\n"
  end

  test "less" do
    get '/css/style-less.css'

    assert_css "body, #less { color: #333333; }\n"
  end
end
