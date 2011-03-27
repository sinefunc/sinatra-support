# I18n support.
#
#   require 'sinatra/support/i18nsupport'
#
#   class Main < Sinatra::Base
#     register Sinatra::I18nSupport
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
# Then put your locale YAML files into +./config/locales+ (whatever path you
# use for {#load_locales}:
#
#   # config/locales/en.yml
#   en:
#     an_article: "An article"
#
# == Helpers
#
# === {Helpers#t t} - Looks up a string.
#
#   <h3><%= t('article.an_article') %></h3>
#   <h5><%= t('article.delete', name: @article.to_s) %></h5>
#
# == {Helpers#current_locale current_locale} - Returns the current locale name.
#
#   <script>
#     window.locale = <%= current_locale.inspect %>;
#   </script>
#
# == {Helpers#locale? locales} - A list of available locales.
#
#   <% if locales.include?(:es) %>
#     <a href="/locales/es">en Espanol</a>
#   <% end %>
#
# == Changing locales
#
# Set +session[:locale]+ to the locale name.
#
#   get '/locales/:locale' do |locale|
#     not_found  unless locales.include?(locale)
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
# == Using a different backend
#
# Instead of calling {#load_locales}, just load the right I18n backend
# using the I18n gem.
#
# == Settings
#
# [+default_locale+]    The locale to use by default. Defaults to +"en"+.
#
module Sinatra::I18nSupport
  def self.registered(app)
    require 'i18n'
    app.set :default_locale, 'en'
    app.helpers Helpers
  end

  # Loads the locales in the given path.
  def load_locales(path)
    Dir[File.join(path, '*.yml')].each do |file|
      I18n.backend.load_translations file
    end
  end

  module Helpers
    # Override this if you need to, say, check for the user's preferred locale.
    def current_locale
      session[:locale] || settings.default_locale
    end

    def locales
      I18n.available_locales
    end

    def t(what, options={})
      I18n.t what, {:locale => current_locale}.merge(options)
    end
  end
end
