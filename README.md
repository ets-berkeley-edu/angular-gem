# Angular-Gem - Just AngularJS
[![Gem Version](https://badge.fury.io/rb/angular-gem.png)](http://badge.fury.io/rb/angular-gem) [![Build Status](https://secure.travis-ci.org/ets-berkeley-edu/angular-gem.png)](http://travis-ci.org/ets-berkeley-edu/angular-gem) [![Dependency Status](https://gemnasium.com/ets-berkeley-edu/angular-gem.png)](https://gemnasium.com/ets-berkeley-edu/angular-gem) [![Code Climate](https://codeclimate.com/github/ets-berkeley-edu/angular-gem.png)](https://codeclimate.com/github/ets-berkeley-edu/angular-gem) [![Coverage Status](https://coveralls.io/repos/ets-berkeley-edu/angular-gem/badge.png?branch=master)](https://coveralls.io/r/ets-berkeley-edu/angular-gem)

This project lets you use AngularJS with the Rails 3.x asset pipeline. It was forked from the [angular-rails gem](https://github.com/ludicast/angular-rails), since the project seems to have been abandoned and there's been a need to keep angularjs up to date within our own internal projects. The version number will by default track the unstable branch, although there are plans to always have both the latest stable and unstable versions available. Looking inside the [vendor folder](https://github.com/ets-berkeley-edu/angular-gem/tree/wip/vendor/assets/javascripts) should give you an idea of what's available.

## Getting Started

Add the gem to your application Gemfile:

    gem "angular-gem"

Run `bundle install`. To bootstrap things, run:

    rails g angular:install

## Specifying versions

- By default, this gem will include the latest stable version of angular with ``//require angular`` in your application.<js/coffee> file.
- You can switch to using the latest unstable version by pointing to ``//require angular-unstable``.
- You can also force specific versions to be loaded with ``//require <VERSION>/angular-<VERSION>``, assuming the source files exist somewhere in the gem.

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
