#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

require 'rake'
# http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html
require 'rake/testtask'
require 'net/http'
require 'nokogiri'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

js_dir = 'vendor/assets/javascripts/'

desc 'Fetches angular.js file from code.angular.js'
task :download do |t|
  version = ENV['VERSION']
  version ||= 'latest'
  puts "Target version: #{version.chomp('/')}"
  additional_components = ENV['COMPONENTS'].split(",") unless ENV['COMPONENTS'].nil?
  additional_components ||= ['resource', 'sanitize']
  components = ['angular'].concat additional_components.map{|entry| "angular-#{entry}"}
  puts "Target components: #{components}"
  angular_root = "code.angularjs.org"
  Net::HTTP.start(angular_root) do |http|
    resp = http.get("/")
    doc = Nokogiri::HTML(resp.body)
    links = doc.css('a')
    known_versions = links.map {|link| link.attribute('href').to_s}.uniq.sort.reverse
    known_versions.delete_if do |href|
      href.empty?  || (href =~ /^([0-9]).*\/$/).nil?
    end

    if !(known_versions.include? version + "/")
      puts "WARN: Specified version='#{version}' not found, setting to latest version: '#{known_versions.first}'"
      version = known_versions.first
    end
  end

  Dir.mkdir(File.join(js_dir, version)) unless Dir.exist?(File.join(js_dir, version))
  Dir.chdir(File.join(js_dir, version)) do
    Net::HTTP.start(angular_root) do |http|
      components.each do |component|
        filename = "#{component}-#{version.chomp('/')}.js"
        next if File.exists?(filename)
        resp = http.get("/#{version}/#{component}.js")
        puts "Creating #{filename}" if resp.is_a?(Net::HTTPSuccess)
        open(filename, "w") { |file| file.write(resp.body)}
      end
    end
  end
end

desc 'Tag the default file versions for asset helpers'
task :tag_default do |t|
  Rake::Task["tag"].invoke
end

desc 'Tag the unstable file versions for asset helpers'
task :tag_unstable do |t|
  ENV['UNSTABLE_TAG'] = "-unstable"
  Rake::Task["tag"].invoke
end

task :tag do |t|
  version = ENV['VERSION']
  version ||= 'latest'
  additional_components = ENV['COMPONENTS'].split(",") unless ENV['COMPONENTS'].nil?
  additional_components ||= ['resource', 'sanitize']
  components = ['angular.js'].concat additional_components.map{|entry| "angular-#{entry}.js"}

  unstable_tag = ENV['UNSTABLE_TAG'] || ''

  puts "Target version: #{version.chomp('/')}"


  Dir.chdir(js_dir) do
    version_directories = Dir.glob("*").select { |fn| File.directory?(fn) }.sort.reverse
    if !(version_directories.include? version)
      puts "WARN: Specified version='#{version}' not found, setting to latest version: '#{version_directories.first}'"
      version = version_directories.first
    end
    new_files = Hash[*Dir.glob("#{version}/*").map {|longfn| [longfn.split(version+'/', 2)[1].chomp("-#{version}.js")+'.js', longfn]}.flatten]
    # Make sure all the components we want are there before overwriting.
    if !(new_files.keys & components == components)
      puts "ERROR: Target version directory does not contain all the components for updating: #{components}"
      exit
    end

    components.each do |file|
      FileUtils.cp new_files[file], file.chomp('.js')+unstable_tag+'.js', {verbose: true}
    end
  end
end

task :default => :test
