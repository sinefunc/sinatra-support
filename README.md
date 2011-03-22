# Sinatra Support
#### A collection of useful utilities.

Helpers:

 - {#Sinatra::CountryHelpers}
 - {#Sinatra::OhmErrorHelpers}
 - {#Sinatra::HtmlHelpers}

Helper providers:

 - {#Sinatra::Numeric}
 - {#Sinatra::Date}

## Common examples
    
    # what are helpers for if you don't have `h` ^_^
    =h "<Bar>"
    
Provided by {#Sinatra::CountryHelpers}:

    %select(name='country')
      != country_choices

Provided by {#Sinatra::Date}:

    %select(name='birthday[month'])
      != month_choices
    
    %select(name='birthday[day]')
      != day_choices

    %select(name='birthday[year'])
      != year_choices
    
Provided by {#Sinatra::HtmlHelpers}:

    %select(name="categories")
      != select_options [['First', 1], ['Second', 2]]
    
Provided by {#Sinatra::Numeric}:

    = currency(100)
    -# displays $ 100.00

    = percentage(100)
    -# displays 100.00%

Provided by {#Sinatra::OhmErrorHelpers}:

    # If you have an ohm model which you want to present the errors of:
    # (this is taken from the reddit-clone courtesy of citrusbyte)
    
    # This should be put in your HAML file

    - errors_on @user do |e|
      - e.on [:email, :not_present] "You must supply an email address"
      - e.on [:password, :not_present] "A password is required"
      - e.on [:password, :not_confirmed] "You must confirm your password"

### Copyright

Copyright (c) 2010 Cyril David, Rico Sta. Cruz and Sinefunc, Inc.
See LICENSE for details.
