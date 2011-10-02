source "http://rubygems.org"

gem "rails", ">= 3.0.3"

group :development, :test do
  gem "jeweler"
  gem "rspec-rails", ">= 2.4.0"
end


# test-environment gems
group :test, :spec, :cucumber do
  gem 'sqlite3-ruby', :require => 'sqlite3'  # needed for the rails-3-app : not really needed, but not sure how to avoid it
  gem "rspec",                   ">= 2.4.0"
  gem "remarkable",              ">=4.0.0.alpha4"
  gem "remarkable_activemodel",  ">=4.0.0.alpha4"
  gem "remarkable_activerecord", ">=4.0.0.alpha4"
#  gem "capybara"
#  gem "cucumber"
#  gem "database_cleaner"
#  gem "cucumber-rails"
end


# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'