require 'date'
require 'sinatra/base'
require File.join(File.dirname(__FILE__), '..', 'sinatra/support/compat-1.8.6')

module Sinatra
  module Support
    VERSION = "0.2.0"

    autoload :Methods,            "sinatra/support/methods"
    autoload :HamlErrorPresenter, "sinatra/support/haml_error_presenter"
    autoload :Country,            "sinatra/support/country"
    
    # @private Sinatra extension writing style.
    # @see http://www.sinatrarb.com/extensions.html#setting_options_and_other_extension_setup
    def self.registered(app)
      app.set :default_year_loffset, -60 
      app.set :default_year_uoffset, 0
      app.set :default_month_names, Date::MONTHNAMES

      app.set :default_currency_unit, '$'
      app.set :default_currency_precision, 2
      app.set :default_currency_separator, ','

      app.helpers Methods
    end
  
  end

  register Support
end
