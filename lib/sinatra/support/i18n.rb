# I18n.
#
#   require 'sinatra/support/i18n'
#
#   class Main < Sinatra::Base
#     register Sinatra::I18n
#     load_locales './config/locales'
#     set :default_locale, 'fr'  # Optional; defaults to 'en'
#   end
#
# Be sure that you have the +I18n+ gem.
#
#   # Gemfile
#   gem "i18n"
#
# (or +gem install i18n+)
#
# == Helpers
#
# === {Helpers#t t} - Looks up a string.
#
#   <h3><%= t('article.create_new_article') %></h3>
#   <h5><%= t('article.delete', name: @article.to_s) %></h5>
#
# == {Helpers#current_locale current_locale} - Returns the current locale name.
#
#   <script>
#     window.locale = <%= current_locale.inspect %>;
#   </script>
#
# == {Helpers#locale? locale?} - Checks if a locale exists.
#
#   <% if locale?('es') %>
#     <a href="/locales/es">en Espanol</a>
#   <% end %>
#
# == Changing locales
#
# Set +session[:locale]+ to the locale name.
#
#   get '/locales/:locale' do |locale|
#     not_found  unless locale?(locale)
#     session[:locale] = locale
#   end
#
# If you want to override the way of checking for the current locale,
# simply redefine the `current_locale` helper:
#
#   helpers do
#     def current_locale
#       current_user.locale || session[:locale] || settings.default_locale
#     end
#   end
#
# == Settings
#
# [+default_locale+]    The locale to use by default. Defaults to +"en"+.
# [+locales+]           A hash of the loaded locales. Populated when calling
#                       {#load_locales}.
#
module Sinatra::I18n
  def self.registered(app)
    require 'i18n'

    app.set :default_locale, 'en'
    app.set :locales, Hash.new

    app.helpers Helpers
  end

  # Loads the locales in the given path.
  def load_locales(path)
    Dir[File.join(path, '*.yml')].each do |file|
       settings.locales.merge! YAML::load_file(file)
    end

    ::I18n.backend.load_translations(app.locales)
  end

  module Helpers
    # Override this if you need to, say, check for the user's preferred locale.
    def current_locale
      session[:locale] || settings.default_locale
    end

    # Checks if a given locale name is defined.
    def locale?(what)
      settings.locales.keys.include?(what)
    end

    def t(*args)
      ::I18n::t *args
    end
  end
end
