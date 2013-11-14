js_dir = 'vendor/assets/javascripts/'

current_path = File.expand_path(File.dirname(__FILE__))
require 'fileutils'

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
  Dir.chdir(File.join(js_dir, version)) do
    %w(zip min.js json txt).each do |file_ext|
      rm Dir.glob("*.#{file_ext}")
    end

    Dir.glob("*.js") do |file|
      mv file, "#{file[0..-4]}-#{version}.js"
    end
  end
end

desc 'Fetches angular.js file from code.angular.js'
task :download do |t|
  version = ENV['VERSION']
  version ||= 'latest'
  puts "Target version: #{version.chomp('/')}"
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

  # Download all the files
  Dir.mkdir(File.join(js_dir, version)) unless Dir.exist?(File.join(js_dir, version))
  Dir.chdir(File.join(js_dir, version)) do
    Net::HTTP.start(angular_root) do |http|
      resp = http.get("/#{version}/")
      doc = Nokogiri::HTML(resp.body)
      links = doc.css('a')
      files = links.map {|link| link.attribute('href').to_s}
      # Select everything apart from the zip file and directories
      files = files.find_all{|item| !item.end_with?('/') && !item.end_with?('.zip')}

      files.each do |file|
        next if File.exists?(file)
        file_download = http.get("/#{version}/#{file}")
        puts "Creating #{file}" if file_download.is_a?(Net::HTTPSuccess)
        open(file, "w") { |file| file.write(file_download.body)}
      end

      # components.each do |component|
      #   filename = "#{component}-#{version.chomp('/')}.js"
      #   next if File.exists?(filename)
      #   resp = http.get("/#{version}/#{component}.js")
      #   puts "Creating #{filename}" if resp.is_a?(Net::HTTPSuccess)
      #   open(filename, "w") { |file| file.write(resp.body)}
      # end
    end
  end
end
