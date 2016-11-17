# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.1'

gem 'sinatra'
gem 'puma'
gem 'json'
gem 'econfig'

gem 'YPBT', '~> 0.2.2'
gem 'sequel'

gem 'ruby-duration', '~> 3.2', '>= 3.2.3'

group :development, :test do
  gem 'sqlite3'
  gem 'pry-byebug'
end

group :test, :production do
  gem 'rake'
end

group :development do
  gem 'rerun'

  gem 'flog'
  gem 'flay'
end

group :test do
  gem 'minitest'
  gem 'minitest-rg'

  gem 'rack-test'

  gem 'vcr'
  gem 'webmock'
end

group :production do
  gem 'pg'
end

group :development, :production do
  gem 'tux'
  gem 'hirb'
end

# group :production do
#   gem 'pg'
# end
