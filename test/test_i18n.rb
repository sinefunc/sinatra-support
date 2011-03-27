require File.expand_path('../helper', __FILE__)

class I18nTest < Test::Unit::TestCase
  include Rack::Test::Methods

  class App < Sinatra::Base
    use Rack::Session::Cookie
    register Sinatra::I18nSupport
    load_locales I18nTest::fixture_path('i18n')

    get('/get') { t('article.new') }
    get('/use/:locale') { |locale| session[:locale] = locale }
  end

  def app
    App.new
  end

  test "en" do
    get '/get'
    assert last_response.body == 'New Article'
  end

  test "session[:locale]" do
    get '/use/tl'
    get '/get'
    assert last_response.body == 'Bagong Artikulo'
  end
end
