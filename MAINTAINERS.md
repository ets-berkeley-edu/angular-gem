## Maintainer guidelines:

- To fetch versions: ``rake download VERSION=X.X.XX``. By default VERSION=latest, which will attempt to scrape the latest version from code.angular.org
- To tag the default version (angular.js. angular-resource.js, etc): ``rake tag_default VERSION=X.X.XX``. Again, by default, VERSION=latest which will attempt to grab the latest version that has been downloaded into vendor/javascripts. Versions have to be downloaded (see the task above) for tagging.
- To tag the "unstable" version (angular-unstable.js, etc): ``rake tag_unstable VERSION=X.X.XX``.
- All rake tasks above accept a ENV['COMPONENTS'], which you can tinker with which additional angular component gets added on top of the main angular library the current default includes: resource, sanitize.

## Maintainer checklist:
1. Run ``rake download`` on the two additional version to include. One for the stable, one for the unstable.
1. Tag the default version to the stable version with ``rake tag_default``
1. Tag the unstable version with ``rake tag_unstable``
1. Update the version inside ``lib/angular-gem/version.rb`` to match the unstable version
  - TODO: looking to streamline this.
1. Run ``gem build angular-gem.gemspec`` to package the gem
1. Do some testing locally against some project that uses the gem (say, like calcentral) to make sure everything work properly.
1. Once satisfied, push the gem up to RubyGems.org with ``gem push angular-gem-<VERSION>.gem``