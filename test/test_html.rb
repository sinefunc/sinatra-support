require File.expand_path('../helper', __FILE__)

class HtmlTest < Test::Unit::TestCase
  include Sinatra::HtmlHelpers

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
