# Allows rendering from multiple engines or renderers.
#
# == Usage
#
#   require 'sinatra/support/multirender'
#
#   class Main < Sinatra::Base
#     register Sinatra::MultiRender
#
#     # These two settings are optional.
#     set :multi_views,   [ './views', './skin/default' ]
#     set :multi_engines, [ :erb, :haml ]
#
#     get '/' do
#       show :home
#     end
#   end
#
# Using #show will automatically find the appropriate template, trying the
# following variations:
#
#   ./views/home.erb
#   ./views/home.haml
#   ./skin/default/home.erb
#   ./skin/default/home.haml
#
module Sinatra::MultiRender
  def self.registered(app)
    views = app.views || './views'

    app.set :multi_engines, Tilt.mappings.keys  unless app.respond_to?(:template_engines)
    app.set :multi_views,   views               unless app.respond_to?(:multi_views)

    app.helpers Helpers
  end

  module Helpers
    # Shows a given template.
    #
    # You may pass +options[:engine]+ to specify which engines you will want
    # to limit the search to. This defaults to +App.multi_engines+, or Tilt's
    # supported engines if that's not defined.
    #
    # You may pass +options[:views]+ to specify which directories to scour.
    # This defaults to +App.multi_views+, or +App.views+.
    #
    # == Examples
    #
    #   # Only HAML
    #   show :home, engine: :haml
    #
    #   # HAML or ERB, favoring HAML first
    #   show :home, engine: [:haml, :erb]
    #
    #   # Only look at certain paths
    #   show :home, views: [ './views', './skins/default' ]
    #
    def show(template, options={}, locals={}, &block)
      paths     = [*(options[:views]  || settings.multi_views)].join(',')
      engines   = [*(options[:engine] || settings.multi_engines)].join(',')

      t = @template_cache.fetch template, options do
        template = Dir["{#{paths}}/#{template}.{#{engines}}"].first  or raise Errno::ENOENT

        ext      = File.extname(template)[1..-1].to_sym
        options  = settings.send(ext).merge(options)  if settings.respond_to?(ext)
        engine   = Tilt[ext]  or raise "Template engine not found: #{ext}"

        engine.new(template, 0, options)
      end

      t.render(self, locals, &block)  if t
    end
  end
end
