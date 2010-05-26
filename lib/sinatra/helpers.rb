require 'date'
require 'sinatra/helpers/compat-1.8.6'

module Sinatra
  module Helpers
    autoload :HamlErrorPresenter, "sinatra/helpers/haml_error_presenter"
    autoload :Country,            "sinatra/helpers/country"

    def country_choices
      Country.to_select
    end
    
    def day_choices
      days = (1..31).to_a
      days.zip(days)
    end

    def month_choices
      Date::MONTHNAMES.map.
        with_index { |month, idx| [month, idx] }.
        tap        { |arr| arr.shift }
    end

    def year_choices(loffset = -20, uoffset = +20)
      years = ((Date.today.year + loffset)..(Date.today.year + uoffset)).to_a
      years.zip(years)
    end

    def select_options(pairs, current)
      pairs.map { |label, value|
        tag(:option, label, :value => value, :selected => (current == value))
      }.join("\n")
    end

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
 
  protected
    def tag(tag, content, atts = {})
      tag_atts = atts.inject("") { |a, (k, v)| 
        a << ('%s="%s"' % [k, v]) if v
        a
      }

      %(<#{ tag } #{ tag_atts }>#{ content }</#{ tag }>)
    end
  end

  register Helpers
end
