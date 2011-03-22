require File.expand_path('../helper', __FILE__)

class NumericTest < Test::Unit::TestCase
  include Sinatra::Numeric::Helpers

  describe "currency" do
    setup do
      settings.stubs(:default_currency_unit).returns('$')
      settings.stubs(:default_currency_precision).returns(2)
      settings.stubs(:default_currency_separator).returns(',')
    end
    
    test "nil" do
      assert_nil currency(nil)
    end

    test "defaults" do
      assert_equal "$ 10.00", currency(10)
    end

    test "with custom unit, precision" do
      assert_equal "&pound; 10.0", currency(10, :unit => "&pound;", :precision => 1)
    end

    test "with 0 precision" do
      assert_equal "$ 10", currency(10, :precision => 0)
    end

    test "separators" do
      assert_equal "$ 100.00", currency(100)
      assert_equal "$ 1,000.00", currency(1_000)
      assert_equal "$ 10,000.00", currency(10_000)
      assert_equal "$ 100,000.00", currency(100_000)
      assert_equal "$ 1,000,000.00", currency(1_000_000)
    end

    test "specified defaults" do
      settings.stubs(:default_currency_unit).returns('P')
      settings.stubs(:default_currency_precision).returns(3)
      settings.stubs(:default_currency_separator).returns(' ')

      assert_equal "P 100.000", currency(100)
      assert_equal "P 1 000.000", currency(1_000)
      assert_equal "P 10 000.000", currency(10_000)
    end
  end

  describe "percentage" do
    test "nil" do
      assert_nil percentage(nil)
    end

    test "various percentages" do
      assert_equal '0.01%', percentage(0.01)
      assert_equal '0.10%', percentage(0.10)
      assert_equal '1%', percentage(1.00)
      assert_equal '10.01%', percentage(10.01)
      assert_equal '99.99%', percentage(99.99)
      assert_equal '100%', percentage(100)
    end
  end
end
