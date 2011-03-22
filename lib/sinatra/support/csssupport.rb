# Support for Sass/SCSS/Less.
#
# == Usage
#
#   require 'sinatra/support/csssupport'
#
# Use {#serve_css} in the Sinatra DSL to serve up files.
#
#   register Sinatra::CssSupport
#   serve_css '/styles', from: './app/css'
#
# Assuming you have a +app/css/print.scss+ file, you will
# then be able to access it from the given URL prefix.
#
#   $ curl "http://localhost:4567/styles/print.css"
#
# This plugin supports Sass, Less and SCSS and guesses by the
# file name.
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
    app.set :css_max_age, 86400*30
  end

  def serve_css(url_prefix, options={})
    path   = File.join(url_prefix, '*.css')
    prefix = options[:from]

    get path do |name|
      fname = Dir[File.join(prefix, "#{name}.{css,scss,less}")].first  or pass

      content_type :css, :charset => 'utf-8'
      last_modified File.mtime(fname)
      cache_control :public, :must_revalidate, :max_age => settings.js_max_age

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
