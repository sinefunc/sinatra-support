module Sinatra
  module Support
    # The actual module containing all of the helper methods.
    # Internally after doing
    #
    #     register Sinatra::Support
    #
    # what happens is it automatically does the following:
    #
    #     helpers Sinatra::Support::Methods
    #
    # which in effect gives you access to all the methods here.
    module Methods
      # Returns an HTML sanitized string.
      def h(str)
        Rack::Utils.escape_html(str)
      end

      # Returns an array of pairs i.e.
      #   
      # - ["Afghanistan", "AF"]
      # - ...
      # - ["United States", "US"]
      # - ...
      # - ["Zimbabwe", "ZW"]
      #
      # @return [Array] the array of name, code pairs.
      def country_choices
        Country.to_select
      end
    
      # Returns an array of pairs i.e.
      #
      # - [1, 1]
      # - [2, 2]
      # - ...
      # - [31, 31]
      #
      # @return [Array] the array of day, day pairs.
      def day_choices
        days = (1..31).to_a
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
      def year_choices(loffset = settings.default_year_loffset, uoffset = settings.default_year_uoffset)
        years = ((Date.today.year + loffset)..(Date.today.year + uoffset)).to_a
        years.zip(years)
      end
    
      # Accepts a list of pairs and produces option tags.
      #
      # @example
      #
      #   select_options([['One', 1], ['Two', 2]])
      #   select_options([['One', 1], ['Two', 2]], 1)
      #   select_options([['One', 1], ['Two', 2]], 1, '- Choose -')
      #
      #   # using it with the provided date helpers...
      #   select_options year_choices, 2010 # select 2010 as default
      #   select_options month_choices, 5 # select May as default
      #   select_options day_choices, 25 # select the 25th as default
      #
      # @param [Array] pairs a collection of label, value tuples.
      # @param [Object] current the current value of this select.
      # @param [#to_s] prompt a default prompt to place at the beginning
      #                of the list.
      def select_options(pairs, current = nil, prompt = nil)
        pairs.unshift([prompt, '']) if prompt

        pairs.map { |label, value|
          tag(:option, label, :value => value, :selected => (current == value))
        }.join("\n")
      end
      
      # Presents errors on your form. Takes the explicit approach and assumes
      # that for every form you have, the copy for the errors are important,
      # instead of producing canned responses.
      #
      # Allows you to do the following in your haml view:
      # 
      # @example
      #   
      #   - errors_on @user do |e|
      #     - e.on [:email, :not_present], "We need your email address."
      #     - e.on [:password, :not_present], "You must specify a password."
      #
      #   # produces the following:
      #   # <div class="errors">
      #   #   <ul>
      #   #     <li>We need your email address</li>
      #   #     <li>You must specify a password.</li>
      #   #   </ul>
      #   # </div>
      #
      # @param [#errors] object An object responding to #errors. This validation
      #                  also checks for the presence of a #full_messages method
      #                  in the errors object for compatibility with 
      #                  ActiveRecord style objects.
      # @param [Hash] options a hash of HTML attributes to place on the
      #               containing div.
      # @option options [#to_s] :class (defaults to errors) The css class to put 
      #                                in the div.
      # @yield [Sinatra::Support::HamlErrorPresenter] an object responding to #on.
      #
      # @see Sinatra::Support::HamlErrorPresenter#on
      def errors_on(object, options = { :class => 'errors' }, &block)
        return if object.errors.empty?

        lines = if object.errors.respond_to?(:full_messages)
          object.errors.full_messages
        else
          HamlErrorPresenter.new(object.errors).present(self, &block)
        end

        haml_tag(:div, options) do
          haml_tag(:ul) do
            lines.each do |error|
              haml_tag(:li, error)
            end
          end
        end
      end
    
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

    protected
      def tag(tag, content, atts = {})
        %(<#{ tag }#{ tag_attributes(atts) }>#{h content}</#{ tag }>)
      end

      def tag_attributes(atts = {})
        atts.inject([]) { |a, (k, v)| 
          a << (' %s="%s"' % [k, escape_attr(v)]) if v
          a
        }.join('')
      end

      def escape_attr(str)
        str.to_s.gsub("'", "&#39;").gsub('"', "&quot;")
      end
    end
  end
end
