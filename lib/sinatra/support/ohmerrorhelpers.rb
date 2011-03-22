# Ohm error helpers.
#
#   # Only for those who use Ohm and HAML.
#   require 'ohm'
#   require 'haml'
#
#   require 'sinatra/support/ohmerrorhelpers'
#
#   class Main < Sinatra::Base
#     helpers Sinatra::OhmErrorHelpers
#   end
#
# == Common usage
# 
#   - errors_on @user do |e|
#     - e.on [:email, :not_present], "We need your email address."
#     - e.on [:password, :not_present], "You must specify a password."
#
# This produces the following:
#
#   <div class="errors">
#     <ul>
#       <li>We need your email address</li>
#       <li>You must specify a password.</li>
#     </ul>
#   </div>
#
module Sinatra::OhmErrorHelpers
  # Presents errors on your form. Takes the explicit approach and assumes
  # that for every form you have, the copy for the errors are important,
  # instead of producing canned responses.
  #
  # @param [#errors] object An object responding to #errors. This validation
  #                  also checks for the presence of a #full_messages method
  #                  in the errors object for compatibility with 
  #                  ActiveRecord style objects.
  # @param [Hash] options a hash of HTML attributes to place on the
  #               containing div.
  # @option options [#to_s] :class (defaults to errors) The css class to put 
  #                                in the div.
  #
  # @yield [Sinatra::Support::HamlErrorPresenter] an object responding to #on.
  #
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

  # @see http://github.com/citrusbyte/reddit-clone
  class HamlErrorPresenter < Ohm::Validations::Presenter
    def on(error, message = (block_given? ? @context.capture_haml { yield } : raise(ArgumentError)))
      handle(error) do
        @output << message
      end
    end

    def present(context)
      @context = context
      super()
    end
  end
end
