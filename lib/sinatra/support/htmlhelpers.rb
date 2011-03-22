# Useful HTML helpers.
#
#   require 'sinatra/support/htmlhelpers'
#
#   class Main < Sinatra::Base
#     helpers Sinatra::HtmlHelpers
#   end
#
# == Helpers
#
# This provides the following helpers:
#
# === {#h h} - Escapes HTML output
#   <a href="<%= h url %>">
#
# === {#tag tag} - Builds HTML tags
#   tag :a                     #=> "<a>"
#   tag :strong, "Yes"         #=> "<strong>Yes</strong>"
#   tag :a, "OK", href: "#"    #=> "<a href='#'>OK</a>"
#
module Sinatra::HtmlHelpers
  # Returns an HTML sanitized string.
  def h(str)
    Rack::Utils.escape_html(str)
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

  # Builds a tag.
  def tag(tag, content, atts = {})
    if self_closing?(tag)
      %(<#{ tag }#{ tag_attributes(atts) } />)
    else
      %(<#{ tag }#{ tag_attributes(atts) }>#{h content}</#{ tag }>)
    end
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

  def self_closing?(tag)
    @self_closing ||= [:area, :base, :basefont, :br, :hr,
                       :input, :img, :link, :meta]

    @self_closing.include?(tag.to_sym)
  end
end
