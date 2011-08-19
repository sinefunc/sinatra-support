require "./lib/sinatra/support/version"
Gem::Specification.new do |s|
  s.name = "sinatra-support"
  s.version = Sinatra::Support.version.to_s
  s.summary = "A gem with many essential helpers for creating web apps with Sinatra."
  s.description = "Sinatra-support includes many helpers for forms, errors and many amazing things."
  s.authors = ["Cyril David", "Rico Sta. Cruz"]
  s.email = ["cyx.ucron@gmail.com", "rico@sinefunc.com"]
  s.homepage = "http://github.com/sinefunc/sinatra-support"

  s.files = Dir["{lib,test}/**/*", "*.md", "Rakefile"].reject { |f| File.directory?(f) }

  s.add_dependency "sinatra", ">= 1.0"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "ohm", "~> 0.0.38"
  s.add_development_dependency "haml", "~> 3.1.2"
  s.add_development_dependency "mocha", "~> 0.9.12"
  s.add_development_dependency "nokogiri", "~> 1.5.0"
  s.add_development_dependency "contest", "~> 0.1.3"
  s.add_development_dependency "compass", "~> 0.11.5"
  s.add_development_dependency "coffee-script", "~> 2.1.1"
  s.add_development_dependency "jsmin", "~> 1.0.1"
end

# gem build *.gemspec
# gem push *.gem
