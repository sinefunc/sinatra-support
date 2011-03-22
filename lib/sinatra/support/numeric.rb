# Numeric.
#
# == Usage
#
#   require 'sinatra/support/numeric'
#
#   class Main < Sinatra::Base
#     register Sinatra::Numeric
#   end
#
# == Settings
#
#   set :default_currency_unit, '$'
#   set :default_currency_precision, 2
#   set :default_currency_separator, ','
#
module Sinatra::Numeric
  def self.registered(app)
    app.set :default_currency_unit, '$'
    app.set :default_currency_precision, 2
    app.set :default_currency_separator, ','

    app.helpers Helpers
  end

  module Helpers
    # Formats a number into a currency display. Uses the following settings:
    #
    # - settings.default_currency_unit      (defaults to '$')
    # - settings.default_currency_precision (defaults to 2)
    # - settings.default_currenty_separator (defaults to ',')
    #
    # @example
    #
    #   currency(100) == "$ 100.00"
    #   # => true
    #
    #   currency(100, :unit => "&pound;") == "&pound; 100.00"
    #   # => true
    #
    #   currency(100, :precision => 0) == "$ 100"
    #   => # true
    #
    #   # somewhere in your sinatra context after registering Sinatra::Support
    #   set :default_currency_unit, '&pound;'
    #   set :default_currency_precision, 3
    #   set :default_currency_separator, ' '
    #
    #   currency(100) == "&pound; 100.000"
    #   # => true
    #
    # @param [Numeric] number the number you wish to display as a currency.
    # @param [Hash] opts the various options available.
    # @option opts [#to_s] :unit (defaults to '$')
    # @option opts [Fixnum] :precision (defaults to 2)
    # @option opts [#to_s] :separator (defaults to ',')
    # @return [String] the formatted string based on `number`.
    # @return [nil] if given nil or an empty string.
    def currency(number, opts = {})
      return if number.to_s.empty?

      unit      = opts[:unit]      || settings.default_currency_unit
      precision = opts[:precision] || settings.default_currency_precision
      separator = opts[:separator] || settings.default_currency_separator

      ret = "%s %.#{ Integer(precision) }f" % [unit, number]
      parts = ret.split('.')
      parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{separator}")
      parts.join('.')
    end

    # Show the percentage representation of a numeric value.
    #
    # @example
    #   percentage(100) == "100.00%"
    #   percentage(100, 0) == "100%"
    #
    # @param [Numeric] number A numeric value
    # @param [Fixnum]  precision (defaults to 2) Number of decimals to show.
    # @return [String] the number displayed as a percentage
    # @return [nil]    given a nil value or an empty string.
    def percentage(number, precision = 2)
      return if number.to_s.empty?

      ret = "%02.#{ precision }f%" % number
      ret.gsub(/\.0*%$/, '%')
    end
  end
end
