# Adds Compass support.
#
# CompassSupport lets you use the Compass CSS framework in your application.
# More information about Compass can be found in http://compass-style.org.
#
# == Usage
#
#   require 'sinatra/support/compasssupport'
#
#   class Main
#     register Sinatra::CompassSupport
#   end
#
# After this, anytime a +sass+ or +scss+ is rendered, you may use Compass's
# extensions by simply importing them (eg, +@import 'compass/layout'+).
#
# == Example
#
# All you need to use is in the section above. Here's a slightly
# more-complicated example:
#
#   class Main
#     register Sinatra::CompassSupport
#
#     get '/' do
#       scss :mysheet
#     end
#   end
#
# And in +views/mysheet.scss+:
#
#   @import 'compass/css3';
#
# == Caveats
#
# When When using with {Sinatra::CssSupport}, you may need to change Compass's 
# +sass_dir+ config to where you're serving CSS files from.
#
#   path = File.join(app.root, 'css')
#
#   serve_css '/css', from: path
#
#   Compass.configuration do |c|
#     c.sass_dir = path
#   end
#
# If you are getting errors about Sass functions, you may need to upgrade your
# HAML and Sass gems.
#
# If your project uses Bundler, you will need to add Compass to your Gemfile.
#
#   # Gemfile
#   gem "compass", "~> 0.11.1"
#
# If you are getting errors about US-ASCII encoding, you may have to change
# your application's default external encoding to +utf-8+.
#
#   Encoding.default_external = 'utf-8'
#
module Sinatra::CompassSupport
  def self.registered(app)
    require 'compass'

    add_compass_engine_options app
  end

private

  def self.add_compass_engine_options(app)
    options = Compass.sass_engine_options

    # Add the compass CSS folders to the path
    [:scss, :sass].each do |type|
      hash = app.respond_to?(type) ? app.send(type) : Hash.new
      hash[:load_paths] ||= Array.new
      hash[:load_paths] += options[:load_paths]

      app.set type, hash
    end
  end
end

