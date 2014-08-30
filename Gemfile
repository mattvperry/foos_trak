source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Haml for view templates
gem 'haml-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
# Twitter bootstrap style framework
gem 'bootstrap-sass'
# Stylesheet autoprefixer
gem 'autoprefixer-rails'
# Authentication with device
gem 'devise'
# Easier form generation
gem 'simple_form', github: 'plataformatec/simple_form'
# Drier controllers with respond_with
gem 'responders'

group :production do
  # Use postgres as the database
  gem 'pg'
  # Use unicorn as the app server
  gem 'unicorn'
  # Enable heroku
  gem 'rails_12factor'
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Interactive ruby debugger
  gem 'pry'
end

ruby '2.1.2'
