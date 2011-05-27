v1.2.0 - May 27, 2011
---------------------

### Added:
  * `Sinatra::CompressedJS` for serving compressed JS files

v1.1.3 - May 27, 2011
---------------------

### Added:
  * `Sinatra::UserAgentHelpers` for browser detection

v1.1.2 - May 27, 2011
---------------------

### Changed:
  * Revise CompassSupport to not use config files (instead just use Compass.configuration)

v1.1.1 - May 27, 2011
---------------------

### Fixed:
  * CssSupport: Fix issue where Sass files are not loaded

v1.1.0 - May 27, 2011
---------------------

### Added:
  * `Sinatra::CompassSupport` to add support for the Compass CSS framework

v1.0.4 - May 15, 2011
---------------------

### Added:
  * Implement `Sinatra::MultiRender`

v1.0.3 - Mar 30, 2011
---------------------

### Added:
  * CssSupport: `css_mtime_for` helper

v1.0.2 - Mar 29, 2011
---------------------

### Added:
  * Implement CssSupport's `css_aggressive_mtime` directive

### Minor changes:
  * Update I18n helpers documentation
  * Update documentation for JsSupport and CssSupport

v1.0.1 - Mar 27, 2011
---------------------

### Added:
  * Implement Sinatra::I18nSupport

### Misc:
  * Update README with URLs
  * Correct the wrong gem name in the documentation

v1.0.0 - Mar 27, 2011
---------------------

Massive 1.0 refactor and massive documentation update. Now sporting a
completely new API and breaks compatibility with 0.2.0.

### Added:
  * CssSupport
  * JsSupport
  * IfHelpers

v0.2.0
------

### Fixed:
  * documentation for private objects / methods

### Added:
  * currency helpers with tests and documentation
  * day_choices
  * full docs to all helper methods
  * link to docs

### Removed:
  * old sinatra-helpers files

### Changed:
  * Allow descending year_choices
  * change how tag works for self_closing
  * Initial renamed sprint from sinatra-helpers
  * Tweak documentation for Methods.rb and load order
  * select option tweaks

v0.1.1
------

### Changed:
  * some tweaks for ruby1.8.6 compat

v0.1.0
------

Initial version.
