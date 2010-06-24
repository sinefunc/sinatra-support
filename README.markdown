Sinatra Support: a common collection of useful utilities
--------------------------------------------------------

Bare minimum, close to the metal helpers for your average sinatra application.
Read the full documentation at [http://labs.sinefunc.com/sinatra-support/doc](http://labs.sinefunc.com/sinatra-support/doc).

Defines...
----------

    # from a Sinatra context point of view...
    set :default_year_loffset, -60 
    set :default_year_uoffset, 0
    set :default_month_names, Date::MONTHNAMES

    set :default_currency_unit, '$'
    set :default_currency_precision, 2
    set :default_currency_separator, ','

Examples
--------
    
    # what are helpers for if you don't have `h` ^_^
    =h "<Bar>"
    
    %select(name='country')
      != country_choices

    %select(name='birthday[month'])
      != month_choices
    
    %select(name='birthday[day]')
      != day_choices

    %select(name='birthday[year'])
      != year_choices
    
    %select(name="categories")
      != select_options [['First', 1], ['Second', 2]]
    
    = currency(100)
    -# displays $ 100.00

    = percentage(100)
    -# displays 100.00%

    # If you have an ohm model which you want to present the errors of:
    # (this is taken from the reddit-clone courtesy of citrusbyte)
    
    # This should be put in your HAML file

    - errors_on @user do |e|
      - e.on [:email, :not_present] "You must supply an email address"
      - e.on [:password, :not_present] "A password is required"
      - e.on [:password, :not_confirmed] "You must confirm your password"

### Copyright

Copyright (c) 2010 Cyril David. See LICENSE for details.
