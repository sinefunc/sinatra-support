require File.expand_path('../helper', __FILE__)

class I18nTest < Test::Unit::TestCase
  include Rack::Test::Methods

  class App < Sinatra::Base
    use Rack::Session::Cookie
    register Sinatra::I18nSupport
    load_locales I18nTest::fixture_path('i18n')

    get('/get') { t('article.new') }
    get('/use/:locale') { |locale| session[:locale] = locale }
    get('/time')  { l(Time.at(141415926)) }
    get('/short') { l(Time.at(141415926), format: :short) }
  end

  def app
    App.new
  end

  test "#t" do
    get '/get'
    assert last_response.body == 'New Article'
  end

  test "session[:locale]" do
    get '/use/tl'
    get '/get'
    assert last_response.body == 'Bagong Artikulo'
  end

  test "#l" do
    get '/time'
    assert_equal 'Wed, 26. Jun 1974 02:12:06 +0800', last_response.body
  end

  test "#l in an alternate locale" do
    get '/use/tl'
    get '/time'
    assert_equal 'Wed, 26. Hun 1974 02:12:06 +0800', last_response.body
  end


  test "#l short" do
    get '/short'
    assert_equal '26. Jun 02:12', last_response.body
  end
end
