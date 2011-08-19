# Serves compressed JS.
#
# == Usage example
#
# Assuming you have JavaScript files stored in +./app/js+, and you want to serve
# the compressed JS in +yoursite.com/js/compressed.js+:
#
#   # CompressedJS is recommended to be used alongside JsSupport to serve
#   # raw JS files in development mode. This will make your /app/js/*.js
#   # accessible via http://yoursite.com/js/*.js.
#
#   register Sinatra::JsSupport
#   serve_js '/js', from: './app/js'
#   
#   register Sinatra::CompressedJS        # Load the CompressedJS plugin
#
#   serve_compressed_js :app_js,          # The name (used later in your views)
#     :prefix => '/js',                   # Where the individual JS files can be accessed at
#     :root   => './app/js',              # The root of your JS files
#     :path   => '/js/compressed.js',     # The URL where the compressed JS will served at
#     :files  =>                          # List of files
#       Dir['./app/js/vendor/*.js'] +
#       Dir['./app/js/app/**.js']
#
# Note that +:prefix+ and +:root+ are the same things passed onto {JsSupport#serve_js serve_js}.
#
# In your template view, add this before +</body>+:
# (The name +app_js+ comes from the first parameter passed to
# {#serve_compressed_js}.)
#
#   <%= settings.app_js.to_html %>
#
# == Example output
#
# In development mode, this will probably output:
#
#   <script src='/js/vendor/jquery.js?1293847189'></script>
#   <script src='/js/app/application.js?1293847189'></script>
#   <!-- This is {:prefix} + {files, stripped of :root} -->
#
# But in production mode:
#
#   <script src='/js/compressed.js?1293847189'></script>
#   <!-- This is {:path} given in serve_compressed_js -->
#
# == Caveats
#
# You will need the JsMin gem.
#
#   # Gemfile
#   gem "jsmin", "~> 1.0.1"
#
# CompressedJS supports CoffeeScript. If you do use CoffeeScript, be
# sure to add the approprate gem to your project.
#
#   # Gemfile
#   gem "coffee-script", require: "coffee_script"
#
# == More functions
#
# Doing +settings.app_js+ returns a {JsFiles} instance. See the {JsFiles} class
# for more info on things you can do.
#
# == Caching
#
# CompressedJS will cache compressed and combined scripts. This means that compression
# will only happen once in your application's runtime.
#
# == Why no support for CSS compression?
#
# If you use Sass/SCSS anyway, you can achieve the same thing by changing Sass's
# :output settings to :compressed. If you also use +@import+ in Sass/SCSS, you can
# easily consolidate all CSS into one file without any need for a Sinatra plugin.
#
# == Extending with another JS compressor
#
# This is unsupported, but you may change the JsFiles.compress function to use
# something else.
#
#   # Sample custom compression (probably doesn't work)
#   def JsFiles.compress(str)
#     file   = Tempfile.new { |f| f.write str }
#     output = Tempfile.new
#
#     system "closure-compiler #{file.path} #{output.path}"
#     output.read
#   end
#
module Sinatra::CompressedJS
  def self.registered(app)
    app.set :jsfiles_cache_max_age, 86400*30  unless app.respond_to?(:jsfile_cache_max_age)
  end

  def serve_compressed_js(name, options={})
    jsfiles = JsFiles.new(options.merge(:app => self))

    set name.to_sym, jsfiles

    serve_jsfiles options[:path], jsfiles
  end

protected
  # Adds a route
  def serve_jsfiles(path, jsfiles)
    get path do
      content_type :js
      last_modified jsfiles.mtime
      etag jsfiles.mtime.to_i
      cache_control :public, :must_revalidate, :max_age => settings.jsfiles_cache_max_age

      jsfiles.compressed
    end
  end
end

# A list of JavaScript files.
#
# This is a general-purpose class usually used for minification
# of JS assets.
#
# This is often used with Sinatra, but can work with any other
# web framework.
#
# === Usage example
#
# In Sinatra, doing {CompressedJS#serve_compressed_js} will make a
# JsFiles instance:
#
#   serve_compressed_js :js_files,
#     :prefix => '/javascript',
#     :path   => '/javascript/combined.js',
#     :root   => './app/js'
#     files   =>
#       Dir['public/js/jquery.*.js'].sort +
#       Dir['public/js/app.*.js'].sort
#
#   js_files.is_a?(JsFiles)  #=> true
#   js_files.mtime           #=> (Time) 2010-09-02 8:00PM
#
# Or outside Sinatra, just instanciate it as so:
# 
#   js_files = JsFiles.new(:files => files,
#     :prefix => '/javascript',
#     :root => './app/js')
#
# You can use #to_html in views:
#
#   <!-- Shows <script> tags -->
#   <%= js_files.to_html %>
#
# Getting the data (for rake tasks perhaps):
#
#   File.open('public/scripts.js', 'w') do |f|
#     f << js_files.combined
#   end
#
#   File.open('public/scripts.min.js', 'w') do |f|
#     f << js_files.compressed
#   end
#
class JsFiles
  attr_reader :files
  attr_reader :app
  attr_reader :prefix
  attr_reader :root
  attr_reader :path

  # Creates a JsFiles object based on the list of given files.
  #
  # @param files [Array] A list of string file paths.
  # @example
  #
  #   files  = Dir['public/js/jquery.*.js']
  #   $js_files = JsFiles.new(files)
  #
  def initialize(options={})
    @app    = options[:app]
    @files  = options[:files]
    @prefix = options[:prefix] || '/js/'
    @path   = options[:path] || @prefix + 'app.js'
    @root   = options[:root] || '/app/js'
    @root   = File.expand_path(@root)

    raise "Files must be an array"  unless @files.is_a?(Array)
  end

  # @group Metadata methods
  
  # Returns the the modified time of the entire package.
  #
  # @return [Time] The last modified time of the most recent file.
  #
  def mtime
    @files.map { |f| File.mtime(f) }.max
  end

  # Returns a list of the URLs for the package.
  #
  # @example
  #
  #   -# This is the same as calling #to_html.
  #   - Main.js_files.hrefs.each do |href|
  #     %script{:src => href}
  #
  def hrefs
    @files.map { |f|
      path = File.expand_path(f)
      path.gsub! /\.[^\.]*$/, ''
      path.gsub! /^#{@root}/, ''
      File.join @prefix, path + ".js?#{File.mtime(f).to_i}"
    }
  end

  # Returns the <script> tags for the development version.
  def to_development_html
    hrefs.map { |href| "<script type='text/javascript' src='#{href}'></script>" }.join("\n")
  end

  # Returns the <script> tag for the production version.
  def to_production_html
    "<script type='text/javascript' src='%s?%s'></script>" % [path, mtime.to_i]
  end

  # Returns the <script> tags, using development or production as needed.
  def to_html
    production? ? to_production_html : to_development_html
  end

  # @group Output methods

  # Returns the combined source of all the files.
  def combined
    @combined ||= @files.map { |file|
      contents = File.open(file) { |f| f.read }
      contents = coffee_compile(contents)  if file =~ /\.coffee$/
      contents
    }.join("\n")
  end

  # Returns a combined, minifed source of all the files.
  def compressed
    require 'jsmin'
    @compressed ||= self.class.compress(combined)
  end

  def self.compress(str)
    JSMin.minify(str).strip
  end

protected
  def coffee_compile(str)
    require 'coffee_script'  unless defined?(::CoffeeScript)
    CoffeeScript.compile(str)
  end

  def production?
    app && app.production?
  end
end
