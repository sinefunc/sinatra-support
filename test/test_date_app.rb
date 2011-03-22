require File.expand_path('../helper', __FILE__)

class DateAppTest < Test::Unit::TestCase
  include Sinatra::Date::Helpers
  include Rack::Test::Methods

  class App < Sinatra::Base
    register Sinatra::Date
    get('/years') { year_choices.to_s }
    get('/months') { month_choices.to_s }
  end

  def app
    App.new
  end

  test "returns the expected years" do
    get '/years'
    
    settings.stubs(:default_year_loffset).returns(-60)
    settings.stubs(:default_year_uoffset).returns(0)

    assert_equal year_choices.to_s, last_response.body
  end

  test "returns the expected months" do
    get '/months'

    settings.stubs(:default_month_names).returns(Date::MONTHNAMES)
    assert_equal month_choices.to_s, last_response.body
  end
end
