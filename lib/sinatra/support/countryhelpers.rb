require File.expand_path('../country', __FILE__)

# Country helpers.
#
#   require 'sinatra/support/countryhelpers'
#   require 'sinatra/support/htmlhelpers'
#
#   class Main < Sinatra::Base
#     helpers Sinatra::HtmlHelpers
#     helpers Sinatra::CountryHelpers
#   end
#
# == Helpers
#
# Provides the following helpers:
#
# === {#country_choices country_choices} - Country choices for select_options.
#
#   <!-- A dropdown box of countries. -->
#   <select name="country">
#     <%= select_options country_choices %>
#   </select>
#
module Sinatra::CountryHelpers
  def country_choices
    Sinatra::Country.to_select
  end
end
