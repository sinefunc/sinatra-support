# Adds a route for JavaScript files.
#
# == Usage
#
#   require 'sinatra/support/jssupport'
#
#   class Main < Sinatra::Base
#     register Sinatra::JsSupport
#     serve_js '/js', from: './app/js'
#   end
#
# You'll be able to access files via +/js+:
#
#   # This will serve /app/js/jquery.js. (or .coffee)
#   $ curl "http://localhost:4567/js/jquery.js"
#
# == CoffeeScript support
#
# This plugin supports CoffeeScript. To use it, simply
# add a CoffeeScript file in the JS file path.
#
#   # Will first try app/js/application.coffee,
#   # then move onto app/js/application.js if it's not found.
#
#   $ curl "http://localhost:4567/js/application.js"
#
# To use CoffeeScript, install the +coffee_script+ gem.
# If you're using Bundler, that is:
#
#   # Gemfile
#   gem "coffee-script", require: "coffee_script"
#
#
module Sinatra::JsSupport
  def self.registered(app)
    app.set :js_max_age, app.development? ? 0 : 86400*30
  end

  def serve_js(url_prefix, options={})
    path   = File.join(url_prefix, '*.js')
    prefix = options[:from]

    get path do |name|
      fname = Dir[File.join(prefix, "#{name}.{js,coffee}")].first  or pass

      content_type :js
      last_modified File.mtime(fname)
      cache_control :public, :must_revalidate, :max_age => settings.js_max_age

      if fname =~ /\.coffee$/
        coffee File.read(fname)
      else
        send_file fname
      end
    end
  end
end
