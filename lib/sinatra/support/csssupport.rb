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
# == Sass caveats
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
# == Less caveats
#
# If you're using Less, it's best you separate your CSS into many files,
# as Less is pretty slow. By default however, CssSupport will ask browsers
# to recache all CSS files even when one is changed, which is to your
# disadvantage considering Less's speed.
#
# You can disable this behavior so that browsers will only fetch CSS files
# that changed.
#
#   register Sinatra::CssSupport
#   Main.set :css_aggressive_mtime, false
#
# == Helpers
#
# {Helpers#css_mtime_for css_mtime_for} - Returns the last modified time for
# the given stylesheet.
#
#   <link rel="stylesheet" type="text/css" href="/css/style.css?<%= css_mtime_for(root('app/css/style.css')) %>">
#
# This takes into account the `css_aggressive_mtime` setting.
# Perfect for nocache hacks, like above.
#
# == Settings
#
# [+css_max_age+]            The maximum time (in seconds) a browser
#                            should hold onto a cached copy.
#                            (default: 30 days)
# [+css_aggressive_mtime+]   If true, ask browsers to recache all CSS files
#                            when one is updated. Default: true
#
module Sinatra::CssSupport
  def self.registered(app)
    app.set :css_max_age, app.development? ? 0 : 86400*30
    app.set :css_aggressive_mtime, true

    app.helpers Helpers
  end

  def serve_css(url_prefix, options={})
    path   = File.join(url_prefix, '*.css')
    prefix = options[:from]

    get path do |name|
      fname = Dir[File.join(prefix, "#{name}.{css,sass,scss,less}")].first  or pass

      content_type :css, :charset => 'utf-8'
      last_modified css_mtime_for(prefix, fname)
      cache_control :public, :must_revalidate, :max_age => settings.css_max_age

      if fname =~ /\.scss$/
        scss File.read(fname)
      elsif fname =~ /\.sass$/
        sass File.read(fname)
      elsif fname =~ /\.less$/
        less File.read(fname)
      else
        send_file fname
      end
    end
  end

  module Helpers
    def css_mtime_for(prefix=nil, fname)
      if settings.css_aggressive_mtime
        prefix ||= File.basename(fname)
        Dir[prefix, "**/*"].map { |f| File.mtime(f).to_i }.max
      else
        File.mtime(fname).to_i
      end
    end
  end
end
