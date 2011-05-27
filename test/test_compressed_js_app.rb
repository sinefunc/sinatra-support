require File.expand_path('../helper', __FILE__)

Encoding.default_external = 'utf-8'

class CompressedJSApp < Test::Unit::TestCase
  include Rack::Test::Methods

  class App < Sinatra::Base
    register Sinatra::CompressedJS
    register Sinatra::JsSupport

    serve_js '/js', from: fx('compressed_js/js')

    serve_compressed_js :app_js,
      :path   => '/js/app.js',
      :prefix => '/js',
      :root   => fx('compressed_js/js'),
      :files  =>
        Dir[fx('compressed_js/js/*.{js,coffee}')].sort

    get('/to_development_html') { settings.app_js.to_development_html }
    get('/to_production_html')  { settings.app_js.to_production_html }
  end

  def app
    App.new
  end

  COMPRESSED = "alert(\"hello\");alert(\"hi\");(function(){alert(2);}).call(this);"

  test "JsFiles#files" do
    assert_equal \
      Dir[fx('compressed_js/js/*.{js,coffee}')].sort,
      App.app_js.files
  end

  test "JsFiles#compressed" do
    assert_equal COMPRESSED, App.app_js.compressed
  end

  test "JsFiles#mtime" do
    assert App.app_js.mtime.to_i > 0
  end

  test "go" do
    get '/js/hi.js'
    control = 'alert("hi");'

    assert_equal control, last_response.body.strip
  end

  test "coffeescript support" do
    get '/js/yo.js'
    control = 'alert(2);';

    assert_equal control, last_response.body.strip
  end

  test "compressed" do
    get '/js/app.js'
    control = COMPRESSED

    assert_equal control, last_response.body.strip
  end

  test "#to_development_html" do
    get '/to_development_html'

    control = /<script type='text\/javascript' src='\/js\/hello\.js\?[0-9]+'>/
    assert_match control, last_response.body

    control = /<script type='text\/javascript' src='\/js\/hi\.js\?[0-9]+'>/
    assert_match control, last_response.body
  end

  test "#to_production_html" do
    get '/to_production_html'

    control = /<script type='text\/javascript' src='\/js\/app\.js\?[0-9]+'>/
    assert_match control, last_response.body
  end
end
