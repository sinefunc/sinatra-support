require File.expand_path('../country', __FILE__)
require File.expand_path('../htmlhelpers', __FILE__)

# Country helpers.
#
# == Common usage
#
#   <!-- A dropdown box of countries. -->
#   <%= select_options country_choices %>
#
# == Usage
#
#   require 'sinatra/support/countryhelpers'
#   require 'sinatra/support/htmlhelpers'
#
#   class Main < Sinatra::Base
#     helpers Sinatra::HtmlHelpers
#     helpers Sinatra::CountryHelpers
#   end
#
module Sinatra::CountryHelpers
  def country_choices
    Sinatra::Country.to_select
  end
end
