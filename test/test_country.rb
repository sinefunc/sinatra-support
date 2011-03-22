require File.expand_path('../helper', __FILE__)

class CountryTest < Test::Unit::TestCase
  include Sinatra::CountryHelpers

  Country = Sinatra::Country

  test "country_choices returns Country.to_select" do
    assert_equal Country.to_select, country_choices  
  end

  test "241 countries" do
    assert_equal 246, Country.to_select.length  
  end

  test "has a matching name for all keys" do
    Country.all.each do |code, name|
      assert_equal name, Country[code]
      assert_equal name, Country[code.to_s]
    end
  end

  test "random returns a valid code" do
    246.times {
      assert Country[Country.random]
    }
  end

  test "finding a country with wrong parameters" do
    assert_nil Country[""]
    assert_nil Country[nil]
    assert_nil Country[:XX]
    assert_nil Country["XX"]
  end
end
