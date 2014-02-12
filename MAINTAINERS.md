## Maintainer guidelines:

- To fetch versions, either first clone the code.angular.js repo or yuhunglin/code.angular.js (just pruned the very old versions) to some local directory. Run ``rake copy SOURCE_DIR=<root of clone> VERSION=<version to copy>`` to copy over the new angular assets to the gem project
- Make sure only the files with .js extension are copied to the gem project(no min.js, js.map or files with extension other than .js)
- To tag the default version (angular.js. angular-resource.js, etc): ``rake tag_default VERSION=X.X.XX``. Again, by default, VERSION=latest which will attempt to grab the latest version that has been downloaded into vendor/javascripts. Versions have to be downloaded (see the task above) for tagging.
- To tag the "unstable" version (angular-unstable.js, etc): ``rake tag_unstable VERSION=X.X.XX``.

## Maintainer checklist:
1. Run ``rake copy`` on the two additional version to include. One for the stable, one for the unstable (if available).
1. Tag the default version to the stable version with ``rake tag_default``
1. Tag the unstable version with ``rake tag_unstable``
1. Update the version inside ``lib/angular-gem/version.rb`` to match the unstable version
  - TODO: looking to streamline this.
1. Run ``gem build angular-gem.gemspec`` to package the gem
1. Do some testing locally against some project that uses the gem (say, like calcentral) to make sure everything work properly.
1. Once satisfied, push the gem up to RubyGems.org with ``gem push angular-gem-<VERSION>.gem``

## How your workflow might look like:

1. Change the version in version.rb
2. Execute the following commands:

```
rake download VERSION=1.2.9
rake tag_default VERSION=1.2.9
git add .
git commit -am "v1.2.9 Release"
git tag -a 1.2.9 -m "v1.2.9 Release"
git push ets master
git push --tags ets master
gem build angular-gem.gemspec
gem push angular-gem-1.2.9.gem
rm angular-gem-1.2.9.gem
```
