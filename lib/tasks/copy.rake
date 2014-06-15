js_dir = 'vendor/assets/javascripts/'

current_path = File.expand_path(File.dirname(__FILE__))
require 'fileutils'
require 'open-uri'

desc 'Copy over source from own pruned angular.code.js repo'
task :copy do |t|
  version = ENV['VERSION'] || ''
  source_dir = ENV['SOURCE_DIR']
  source_dir ||= '/opt/code.angularjs.org'
  source_dir = File.expand_path source_dir

  if !File.exists?(source_dir) || File.file?(source_dir)
    p 'SOURCE_DIR is not a directory or does not exist'
    next
  end

  if version.empty? || !File.exist?(File.join(source_dir, version))
    p 'VERSION must target existing version in SOURCE_DIR'
    next
  end

  puts "Target version: #{version.chomp('/')}"

  source_version = File.join(source_dir, version)
  cp_r source_version, js_dir
  rm_rf File.join(js_dir, version, 'docs')
  rm_rf File.join(js_dir, version, 'i18n')
  Dir.chdir(File.join(js_dir, version)) do
    %w(zip min.js json txt js.map css).each do |file_ext|
      rm Dir.glob("*.#{file_ext}")
    end

  end
end

desc 'Fetches angular.js file from code.angular.js'
task :download do |t|
  version = ENV['VERSION']
  version ||= 'latest'
  puts "Target version: #{version.chomp('/')}"
  angular_root = "https://code.angularjs.org"
  response = open(angular_root)
  doc = Nokogiri::HTML(response)
  links = doc.css('a')
  known_versions = links.map {|link| link.attribute('href').to_s}.uniq.sort.reverse
  known_versions.delete_if do |href|
    href.empty?  || (href =~ /^([0-9]).*\/$/).nil?
  end

  if !(known_versions.include? version + "/")
    puts "WARN: Specified version='#{version}' not found, setting to latest version: '#{known_versions.first}'"
    version = known_versions.first
  end

  # Download all the files
  Dir.mkdir(File.join(js_dir, version)) unless Dir.exist?(File.join(js_dir, version))
  Dir.chdir(File.join(js_dir, version)) do
    response = open("#{angular_root}/#{version}/")
    doc = Nokogiri::HTML(response)
    links = doc.css('a')
    files = links.map {|link| link.attribute('href').to_s}
    # Select everything apart from the zip file and directories
    # files = files.find_all{|item| !item.end_with?('/') && !item.end_with?('.zip')}
    files = files.find_all{|item| !item.end_with?('min.js') && item.end_with?('.js')}

    files.each do |file|
      next if File.exists?(file)
      path = "#{angular_root}/#{version}/#{file}"
      puts "Creating #{file}"
      File.open(file, 'wb') do |filer|
        filer.write open(path).read
      end
    end
  end
end
