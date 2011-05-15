require File.expand_path('../helper', __FILE__)

class MultiRenderTest < Test::Unit::TestCase
  include Rack::Test::Methods

  class App < Sinatra::Base
    register Sinatra::MultiRender

    set :multi_views, [
      File.expand_path('../fixtures/multirender/views_1', __FILE__),
      File.expand_path('../fixtures/multirender/views_2', __FILE__)
    ]

    get('/')          { show :home }
    get('/contact')   { show :contact }
    get('/dupe/haml') { show :dupe, engine: :haml }
    get('/dupe/erb')  { show :dupe, engine: [:erb] }
    get('/dupe/erb2') { show :dupe, engine: [:erb, :haml] }
  end

  def app
    App.new
  end

  test "picking one" do
    get '/'
    assert last_response.body.strip == '<html>from 1</html>'
  end

  test "picking one from the second path" do
    get '/contact'
    assert last_response.body.strip == '<html>contact</html>'
  end

  test "specifying engines" do
    get '/dupe/haml'
    assert last_response.body.strip == '<span>From HAML</span>'
  end

  test "specifying engines (2)" do
    get '/dupe/erb'
    assert last_response.body.strip == '<span>From ERB</span>'
  end

  test "specifying engines (2)" do
    get '/dupe/erb2'
    assert last_response.body.strip == '<span>From ERB</span>'
  end

  test "single view path" do
    old = App.multi_views

    App.set :multi_views, fixture_path('multirender/views_2')

    get '/'
    assert last_response.body.strip == '<html>from 2</html>'

    App.set :multi_views, old
  end
end
