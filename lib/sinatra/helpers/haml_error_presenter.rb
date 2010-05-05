module Sinatra
  module Helpers
    # Taken from http://github.com/citrusbyte/reddit-clone
    # Credit goes to citrusbyte.
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
end
