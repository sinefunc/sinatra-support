require "helper"

class SintatraHelpersTest < Test::Unit::TestCase
  include Sinatra::Helpers
  
  attr :settings

  test "country_choices returns Country.to_select" do
    assert_equal Country.to_select, country_choices  
  end
  
  test "day_choices returns 1 to 31" do
    assert_equal 31, day_choices.size
    assert_equal [1, 1], day_choices.first
    assert_equal [31, 31], day_choices.last

    day_choices.each do |label, value|
      assert_equal label, value
    end
  end
  
  describe "month choices" do
    setup do
      @settings = stub("Settings", :default_month_names => Date::MONTHNAMES)
    end
    
    test "by default" do
      assert_equal ["January",   1], month_choices[0]
      assert_equal ["February",  2], month_choices[1]
      assert_equal ["March",     3], month_choices[2]
      assert_equal ["April",     4], month_choices[3]
      assert_equal ["May",       5], month_choices[4]
      assert_equal ["June",      6], month_choices[5]
      assert_equal ["July",      7], month_choices[6]
      assert_equal ["August",    8], month_choices[7]
      assert_equal ["September", 9], month_choices[8]
      assert_equal ["October",  10], month_choices[9]
      assert_equal ["November", 11], month_choices[10]
      assert_equal ["December", 12], month_choices[11]
    end

    test "given Date::ABBR_MONTHNAMES" do
      month_choices = month_choices(Date::ABBR_MONTHNAMES)

      assert_equal ["Jan",  1], month_choices[0]
      assert_equal ["Feb",  2], month_choices[1]
      assert_equal ["Mar",  3], month_choices[2]
      assert_equal ["Apr",  4], month_choices[3]
      assert_equal ["May",  5], month_choices[4]
      assert_equal ["Jun",  6], month_choices[5]
      assert_equal ["Jul",  7], month_choices[6]
      assert_equal ["Aug",  8], month_choices[7]
      assert_equal ["Sep",  9], month_choices[8]
      assert_equal ["Oct", 10], month_choices[9]
      assert_equal ["Nov", 11], month_choices[10]
      assert_equal ["Dec", 12], month_choices[11]
    end
    
    test "when changing settings.default_month_names" do
      settings.expects(:default_month_names).at_least_once.returns(Date::ABBR_MONTHNAMES)

      assert_equal ["Jan",  1], month_choices[0]
      assert_equal ["Feb",  2], month_choices[1]
      assert_equal ["Nov", 11], month_choices[10]
      assert_equal ["Dec", 12], month_choices[11]
    end
  end

  describe "year choices" do
    setup do
      @settings = stub("Settings", :default_year_loffset => -60,
                                   :default_year_uoffset => 0)
    end
    
    test "by default" do
      assert_equal 61, year_choices.size
      year_choices.each do |label, value|
        assert_equal label, value
      end
    end

    test "allows to pass in a lower upper offset" do
      assert_equal 1, year_choices(0, 0).size
      assert_equal [Date.today.year, Date.today.year], year_choices(0, 0).first
      
      Date.expects(:today).at_least_once.returns(Date.new(2010, 5, 5))
      assert_equal [2005, 2005], year_choices(-5).first
      assert_equal [2015, 2015], year_choices(0, 5).last
    end

    test "allows to customize via global settings" do
      settings.expects(:default_year_loffset).at_least_once.returns(0)
      settings.expects(:default_year_uoffset).at_least_once.returns(6)

      expected = (2010..2016).to_a
      expected = expected.zip(expected)

      assert_equal expected, year_choices
    end
  end

  context "in a real sinatra app" do
    class App < Sinatra::Base
      register Sinatra::Helpers

      get '/years' do
        year_choices.to_s
      end

      get '/months' do
        month_choices.to_s
      end
    end

    include Rack::Test::Methods

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

  describe "select_options" do
    test "displays the pairs" do
      html = select_options([['One', 1], ['Two', 2]])
      doc  = Nokogiri(%(<body>#{html}</body>))

      assert_equal 'One', doc.search('option[value="1"]').text
      assert_equal 'Two', doc.search('option[value="2"]').text
    end

    test "marks option as selected" do
      html = select_options([['One', 1], ['Two', 2]], 1)
      doc  = Nokogiri(%(<body>#{html}</body>))

      assert_equal 'One', doc.search('option[value="1"][selected]').text
      assert_equal 'Two', doc.search('option[value="2"]').text
    end

    test "produces a prompt properly" do
      html = select_options([['One', 1], ['Two', 2]], 1, "- Choose -")
      doc  = Nokogiri(%(<body>#{html}</body>))
    
      assert_equal '- Choose -', doc.search('option[value=""]').text
      assert_equal 'One', doc.search('option[value="1"][selected]').text
      assert_equal 'Two', doc.search('option[value="2"]').text
    end
  end
end
