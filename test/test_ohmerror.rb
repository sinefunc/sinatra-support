require File.expand_path('../helper', __FILE__)

class OhmErrorTest < Test::Unit::TestCase
  describe "errors_on" do
    include Rack::Test::Methods

    class App < Sinatra::Base
      FORM = (<<-FORM).gsub(/^ {6}/, '')
      - errors_on @post do |e|
        - e.on [:email, :not_present], "Email is required."
        - e.on [:name, :not_present], "Name is required."
      FORM

      helpers Sinatra::OhmErrorHelpers

      class Post < Ohm::Model
        attribute :email
        attribute :name

        def validate
          assert_present :email
          assert_present :name
        end
      end

      get '/form' do
        @post = Post.new
        @post.valid?

        haml FORM
      end
    end

    def app
      App.new
    end

    test "produces proper errors" do
      get '/form'
    
      doc = Nokogiri(last_response.body)

      assert_equal 1, doc.search('div.errors').length

      assert_equal 'Email is required.', 
        doc.search('div.errors > ul > li:first-child').text

      assert_equal 'Name is required.',
        doc.search('div.errors > ul > li:last-child').text
    end
  end
end
