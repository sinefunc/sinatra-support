require File.expand_path('../helper', __FILE__)

class DateTest < Test::Unit::TestCase
  include Sinatra::Date::Helpers

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
      settings.stubs(:default_month_names).returns(Date::MONTHNAMES)
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
      settings.stubs(:default_month_names).at_least_once.returns(Date::ABBR_MONTHNAMES)

      assert_equal ["Jan",  1], month_choices[0]
      assert_equal ["Feb",  2], month_choices[1]
      assert_equal ["Nov", 11], month_choices[10]
      assert_equal ["Dec", 12], month_choices[11]
    end
  end

  describe "year choices" do
    setup do
      settings.stubs(:default_year_loffset).returns(-60)
      settings.stubs(:default_year_uoffset).returns(0)
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

    test "allows to start with a higher lower upper offset" do
      Date.expects(:today).at_least_once.returns(Date.new(2010, 5, 5))
      assert_equal [2010, 2010], year_choices(0, -50).first
      assert_equal [1960, 1960], year_choices(0, -50).last
    end

    test "allows to customize via global settings" do
      settings.expects(:default_year_loffset).at_least_once.returns(0)
      settings.expects(:default_year_uoffset).at_least_once.returns(6)

      year = Time.now.year
      expected = (year..(year+6)).to_a
      expected = expected.zip(expected)

      assert_equal expected, year_choices
    end
  end
end
