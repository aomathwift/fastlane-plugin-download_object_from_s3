source('https://rubygems.org')

gemspec

gem 'aws-sdk', '~> 3'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
