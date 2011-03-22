require File.expand_path('../support/version', __FILE__)

module Sinatra
  autoload :Country,         File.expand_path('../support/country', __FILE__)
  autoload :CountryHelpers,  File.expand_path('../support/countryhelpers', __FILE__)
  autoload :Date,            File.expand_path('../support/date', __FILE__)
  autoload :OhmErrorHelpers, File.expand_path('../support/ohmerrorhelpers', __FILE__)
  autoload :HtmlHelpers,     File.expand_path('../support/htmlhelpers', __FILE__)
  autoload :Numeric,         File.expand_path('../support/numeric', __FILE__)

  module Support
  end
end
