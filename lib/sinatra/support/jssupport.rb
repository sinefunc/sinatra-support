# Adds a route for JavaScript files.
#
# == Usage
#
#   require 'sinatra/support/jssupport'
#
# Use {#serve_js} in the Sinatra DSL to serve up files.
#
#   register Sinatra::JsSupport
#   serve_js '/js', from: './app/js'
#
# Assuming you have a +app/js/jquery.js+ file, you will
# then be able to access it from the given URL prefix.
#
#   $ curl "http://localhost:4567/js/jquery.js"
#
# This plugin supports CoffeeScript. To use it, simply
# add a CoffeeScript file in the JS file path.
#
#   # Will first try app/js/application.coffee,
#   # then move onto app/js/application.js if it's not found.
#
#   $ curl "http://localhost:4567/js/application.js"
#
# To use CoffeeScript, you will need the +coffee_script+ gem.
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
