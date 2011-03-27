# Support for Sass/SCSS/Less.
#
#   require 'sinatra/support/csssupport'
#
#   class Main < Sinatra::Base
#     register Sinatra::CssSupport
#     serve_css '/styles', from: './app/css'
#   end
#
# You'll be able to access files via +/styles+:
#
#   # This will serve /app/css/print.css
#   $ curl "http://localhost:4567/styles/print.css"
#
# == Sass/SCSS/Less support
#
# This plugin supports Sass, Less and SCSS and guesses by the
# file name.
#
#   # Will serve /app/css/screen.css (or .sass, .less, .scss)
#   # ...whichever it can find first.
#
#   $ curl "http://localhost:4567/styles/screen.css
#
# For Sass/SCSS support, install the +haml+ gem. For Less, use
# the +less+ gem. If you're using Bundler:
#
#   # Gemfile
#   gem "haml"
#   gem "less"
#
# == Caveats
#
# Note that you will need to set your Sass/SCSS +load_path+ settings.
#
#   Main.configure do |m|
#     m.set :scss, {
#       :load_paths => [ 'app/css' ]
#     }
#     m.set :scss, self.scss.merge(:style => :compressed) if m.production?
#   end
#
module Sinatra::CssSupport
  def self.registered(app)
    app.set :css_max_age, app.development? ? 0 : 86400*30
  end

  def serve_css(url_prefix, options={})
    path   = File.join(url_prefix, '*.css')
    prefix = options[:from]

    get path do |name|
      fname = Dir[File.join(prefix, "#{name}.{css,scss,less}")].first  or pass

      content_type :css, :charset => 'utf-8'
      last_modified File.mtime(fname)
      cache_control :public, :must_revalidate, :max_age => settings.css_max_age

      if fname =~ /\.scss$/
        scss File.read(fname)
      elsif fname =~ /\.scss$/
        sass File.read(fname)
      elsif fname =~ /\.less$/
        less File.read(fname)
      else
        send_file fname
      end
    end
  end
end
