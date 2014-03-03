VERSION=$1

echo $VERSION

sed -i "" "s/[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*/$VERSION/g" lib/angular-gem/version.rb
rake download VERSION=${VERSION}
rake tag_default VERSION=${VERSION}
git add .
git commit -am "v${VERSION} Release"
git tag -a ${VERSION} -m "v${VERSION} Release"
git push ets master
git push --tags ets master
gem build angular-gem.gemspec
gem push angular-gem-${VERSION}.gem
rm angular-gem-${VERSION}.gem
