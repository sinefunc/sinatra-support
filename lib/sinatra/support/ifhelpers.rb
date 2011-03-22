# Useful HAML condition helpers.
#
#   require 'sinatra/support/htmlhelpers'
#
#   class Main < Sinatra::Base
#     helpers Sinatra::IfHelpers
#   end
#
# == Helpers
#
# These are helpers you can use in HAML files.
#
# === {#active_if active_if} - Adds +class='active'+ if a condition passes.
#
#   - @users.each do |user|
#     %li{active_if(user == current_user)}
#       = user.to_s
#
# === {#checked_if checked_if} - Adds +checked=1+.
#
#   %input{checked_if(page.available?), type: 'checkbox'}
#
# === {#hide_if hide_if} - Adds +style='display:none'+.
#
#   #comments{hide_if(post.comments.empty?)}
#
# === {#show_if show_if} - Inverse of +hide_if+.
#
# === {#selected_if selected_if} - Adds +selected=1+.
#
# === {#disabled_if disabled_if} - Adds +disabled=1+.
#
# === {#enabled_if enabled_if} - Inverse of +disabled_if+.
#
module Sinatra::IfHelpers
  def active_if(condition)
    condition ? {:class => 'active'} : {}
  end

  def checked_if(condition)
    condition ? {:checked => '1'} : {}
  end

  def selected_if(condition)
    condition ? {:selected => '1'} : {}
  end

  def disabled_if(condition)
    condition ? {:disabled => '1'} : {}
  end

  def enabled_if(condition)
    disabled_if !condition
  end

  def hide_if(condition)
    condition ? {:style => 'display:none'} : {}
  end

  def show_if(condition)
    hide_if !condition
  end
end
