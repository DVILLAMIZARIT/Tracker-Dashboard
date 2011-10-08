source 'http://rubygems.org'

#gem 'rails', '3.1.0.rc5'
gem 'rails', '3.1.0'
gem 'rack', '1.3.3'

gem 'bson_ext'
gem 'rails_config'

gem 'haml'
gem 'sass'

gem 'jquery-rails' # not sure this even did anything.  I'm using the one served by Google's CDN
gem 'rails3-jquery-autocomplete'

gem 'simple_form'

gem 'pivotal-tracker', '0.4.1', :git => "git://github.com/jsmestad/pivotal-tracker.git"

gem 'heroku'
gem 'uglifier'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :test do
  gem 'cucumber-rails'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'launchy'
  gem 'jasmine'
  gem 'factory_girl_rails'
end

group :development, :test do

  gem 'sqlite3'
  gem 'sqlite3-ruby', :require => 'sqlite3'
  #gem 'ruby-debug19'
  gem 'haml-rails'
  gem 'faker'
end

group :production do
  gem 'pg'
end
