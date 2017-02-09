source 'https://rubygems.org'
# Gems required by redmine_dashboard

send :ruby, RUBY_VERSION if ENV['CI']

gem 'haml'
gem 'byebug'

group :development do
  gem 'transifex-ruby-fork-jg', require: false
  gem 'inifile', require: false
  #gem 'byebug' 
end

group :test do
  gem 'rspec', '>= 2.0'
  gem 'rspec-rails', '>= 2.0'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'fuubar'
end
