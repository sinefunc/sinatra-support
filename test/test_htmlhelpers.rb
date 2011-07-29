require File.expand_path('../helper', __FILE__)

class HtmlHelpersTest < Test::Unit::TestCase
  include Sinatra::HtmlHelpers

  describe "tag" do
    test "the basic no attr case" do
      assert_equal '<div>Foobar</div>', tag('div', 'Foobar')
    end

    test "one attr case" do
      assert_equal '<div class="baz">Foobar</div>', 
        tag('div', 'Foobar', :class => 'baz')
    end

    test "many attrs case" do
      assert_equal '<div class="baz bar" style="display:none">Foobar</div>', 
        tag('div', 'Foobar', :class => 'baz bar', :style => 'display:none')
    end

    test "funky attrs case" do
      assert_equal '<div class="baz &#39;bar&#39;" ' +
                   'style="display:&quot;none&quot;">Foobar</div>', 
        tag('div', 'Foobar', :class => "baz 'bar'", :style => 'display:"none"')
    end
  end
  
  test "h" do
    assert_equal "&lt;Foo&gt;", h("<Foo>")
    assert_match /^&lt;Foo bar=&#.*?;baz&#.*?;&gt;$/, h("<Foo bar='baz'>")
    assert_equal "&lt;Foo bar=&quot;baz&quot;&gt;", h("<Foo bar=\"baz\">")
  end
end
