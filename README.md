# Angularjs-Rails - Just AngularJS [![Build Status](https://secure.travis-ci.org/ets-berkeley-edu/angularjs-rails.png)](http://travis-ci.org/ets-berkeley-edu/angularjs-rails)

This project lets you use angularjs with the Rails 3.x asset pipeline. It was forked from the [angular-rails gem](https://github.com/ludicast/angular-rails), since the project seems to have been abandoned and there's been a need to keep angularjs up to date within our own internal projects.

## Getting Started

Add the gem to your application Gemfile:

    gem "angularjs-rails"

Run `bundle install`. To bootstrap things, run:

    rails g angular:install

### Layout and namespacing

Running `rails g angular:install` will create the following directory structure under `app/assets/javascripts/angular`:

    controllers/
    filters/
    services/
    widgets/

It will also generate a `templates/` directory under app assets, where view templates can be stored.  This lets you use haml, etc. for your angular views.

It will also add to the application.js file the appropriate requires.

## Generators

angular-rails provides a simple generator to help get you started using angular.js with rails 3.1.  The generators will only create client side code (javascript).

So far we have a controller generator which generates a controller file if you rum

    rails g angular:controller MODELNAME

This file is empty except for the class declaration, but I will be adding some RESTful controller functionality shortly.
