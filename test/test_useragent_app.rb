require File.expand_path('../helper', __FILE__)

Encoding.default_external = 'utf-8'

class UserAgentAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  class App < Sinatra::Base
    helpers Sinatra::UserAgentHelpers
    get('/class') { "<body class='#{browser.body_class}'>" }
  end

  UA_CHROME = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_7) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.68 Safari/534.24"

  def app
    App.new
  end

  test "boogie" do
    header 'User-Agent', UA_CHROME
    get '/class'

    assert_equal "<body class='webkit chrome osx mac'>", last_response.body.strip
  end
end
