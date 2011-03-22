require File.expand_path('../compat-1.8.6.rb', __FILE__)

# Date helpers.
#
# == Usage
#
#   require 'sinatra/support/date'
#
#   class Main < Sinatra::Base
#     register Sinatra::Date
#   end
#
# == Helpers
#
# - {Helpers#day_choices}
# - {Helpers#month_choices}
# - {Helpers#year_choices}
#
# == Settings
# 
# Provides the following settings in your application:
#
# [default_year_loffset]   (Numeric) How many years back to display.
#                          Defaults to `-60`.
# [default_year_loffset]   (Numeric) How many years forward. Defaults
#                          to `0`.
# [default_month_names]    (Array) The names of the months. Defaults
#                          To `Date::MONTHNAMES`.
#
# You may change them like this:
#
#   Main.configure do |m|
#     m.set :default_year_loffset, -60 
#     m.set :default_year_uoffset, 0
#     m.set :default_month_names, Date::MONTHNAMES
#   end
#
module Sinatra::Date
  def self.registered(app)
    app.set :default_year_loffset, -60
    app.set :default_year_uoffset, 0
    app.set :default_month_names, Date::MONTHNAMES

    app.set :default_currency_unit, '$'
    app.set :default_currency_precision, 2
    app.set :default_currency_separator, ','

    app.helpers Helpers
  end

  module Helpers
    # Returns an array of pairs i.e.
    #
    # - [1, 1]
    # - [2, 2]
    # - ...
    # - [31, 31]
    #
    # @return [Array] the array of day, day pairs.
    def day_choices(max=31)
      days = (1..max).to_a
      days.zip(days)
    end
    
    # Returns an array of pairs i.e.
    # - ['January', 1]
    # - ['February', 2]
    # - ...
    # - ['December', 12]
    #
    # You may pass in Date::ABBR_MONTHNAMES if you want the shortened month names.
    #
    # @param  [Array] month_names (defaults to Date::MONTHNAMES) an array with the
    #                 first element being nil, element 1 being January, etc.
    # @return [Array] the array of month name, month pairs.
    def month_choices(month_names = settings.default_month_names)
      month_names.map.
        with_index { |month, idx| [month, idx] }.
        tap        { |arr| arr.shift }
    end

    # Returns an array of pairs i.e.
    # - [2005, 2005]
    # - [2006, 2006]
    # - ...
    # - [2010, 2010]
    #
    # @example
    #
    #   year_choices # assuming it's now 2010
    #   # => [[1950, 1950], ..., [2010, 2010]]
    #
    #   # we can pass in options
    #   year_choices(0, 6) # like for credit card options
    #   # => [[2010, 2010], ..., [2016, 2016]]
    #
    #   # also we can override settings at the app level
    #   set :default_year_loffset, 0
    #   set :default_year_uoffset, 6
    #   year_choices
    #   # => [[2010, 2010], ..., [2016, 2016]]
    #
    # @param [Fixnum] loffset (defaults to -60) The lower offset relative to the current year.
    #                 If it's 2010 now, passing in -5 here will start the year
    #                 list at 2005 for example.
    # @param [Fixnum] uoffset (defaults to 0) The upper offset relative to the 
    #                 current year. If it's 2010 now, passing in 5 or +5 here 
    #                 will end the year list at 2015 for example.
    # @return [Array] the array of year, year pairs.
    #
    def year_choices(loffset = settings.default_year_loffset, uoffset = settings.default_year_uoffset)
      start  = loffset + Date.today.year
      finish = uoffset + Date.today.year
      
      enum   = start < finish ? start.upto(finish) : start.downto(finish)
      enum.map { |e| [e, e] }
    end
  end
end
