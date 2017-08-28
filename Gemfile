source 'https://rubygems.org'

gem 'rails', '~> 4'

gem 'dotenv-rails', require: 'dotenv/rails-now', groups: %i(development test)

gem 'active_model_serializers', git: 'https://github.com/rails-api/active_model_serializers', branch: '0-9-stable'
gem 'airbrussh'
gem 'animate-rails'
gem 'app_konfig'
gem 'attr_extras'
gem 'auth0'
gem 'celluloid-io', require: ['celluloid/current', 'celluloid/io']
gem 'crono'
gem 'decent_exposure'
gem 'easy_tokens'
gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'gravatar-ultimate'
gem 'haml-rails'
gem 'hashie-forbidden_attributes'
gem 'jquery-rails'
gem 'kaminari'
gem 'lograge'
gem 'netguru_theme'
gem 'omniauth'
gem 'omniauth-slack'
gem 'pg'
gem 'pundit'
gem 'react_webpack_rails'
gem 'redis-namespace'
gem 'rollbar'
gem 'rwr-redux'
gem 'sass-rails'
gem 'searchlight'
gem 'sendgrid'
gem 'sidekiq'
gem 'skylight'
gem 'slack-ruby-client'
gem 'sprockets-rails'
gem 'thin'
gem 'uglifier'
gem 'whenever', require: false

# deploy
gem 'capistrano', '3.3.5'
gem 'capistrano-docker', git: 'https://github.com/netguru/capistrano-docker', tag: 'v0.2.6'

source 'https://rails-assets.org' do
  gem 'rails-assets-select2', '3.5.2'
end

gem 'rails_12factor', group: :production

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'foreman'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'html2haml'
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'rack-mini-profiler'
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'bundler-audit', require: false
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'guard-rubocop'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails'
  gem 'timecop'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'shoulda-matchers', '~> 3.1'
end
