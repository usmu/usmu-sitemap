source 'https://rubygems.org'

# Specify your gem's dependencies in usmu.gemspec
gemspec name: 'usmu-sitemap'

gem 'codeclimate-test-reporter', group: :test, require: nil

if RUBY_VERSION.to_f >= 2 && RUBY_VERSION.to_f < 2.2 && RUBY_ENGINE == 'ruby'
  gem 'mutant', '~> 0.7', :group => :development
  gem 'mutant-rspec', '~> 0.7', :group => :development
end
