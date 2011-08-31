# Allows you to write parts of an application as a module.
#
# == Usage
#
#   require 'sinatra/support'
#   # or require 'sinatra/support/appmodule'
#   
# Create a part of your application by placing the usual Sinatra directives
# (@@get@@, @@helpers@@, @@configure@@, etc) in a module. Be sure to @@include
# Sinatra::AppModule@@ first.
#
#   module LoginModule
#     include Sinatra::AppModule
#
#     helpers do
#       def logged_in?
#         # ...
#       end
#     end
#
#     get '/login' do
#       # ...
#     end
#   end
#
# In your Sinatra application, simply include the module to bring those routes
# and helpers in.
#
#   class MyApplication < Sinatra::Base
#     include LoginModule
#   end
#
module Sinatra::AppModule
  def self.included(controller)
    controller.extend ClassMethods
  end

  module ClassMethods
    def included(app)
      deferred.each { |(method, args, blk)| app.send method, *args, &blk }
    end

    def method_missing(meth, *args, &blk)
      defer meth, *args, &blk
      nil
    end

    def defer(what, *a, &blk)
      deferred << [what, a, blk]
    end

    def deferred
      @deferred ||= Array.new
    end
  end
end
