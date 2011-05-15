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
  s.add_development_dependency "ohm"
  s.add_development_dependency "haml"
  s.add_development_dependency "mocha"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "contest"
end

# gem build *.gemspec
# gem push *.gem
