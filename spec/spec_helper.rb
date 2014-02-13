require 'rubygems'
require 'spork'
ENV['RACK_ENV'] = 'test'                    # force the environment to 'test'
ENV["MONGO_DB_NAME"] = "TestDb"

ENV["USER_NAME"] = "admin"
ENV["USER_PASSWORD"] = "admin"

ENV["PASSWORD_PROTECTED"] = "true"


Spork.prefork do
  require File.join(File.dirname(__FILE__), '..', 'backend.rb')

  require 'rubygems'
  require 'sinatra'
  require 'rspec'
  require 'rack/test'
  require 'capybara'
  require 'capybara/dsl'

  Capybara.app = Backend        # in order to make Capybara work

  # set test environments
  set :environment, :test
  set :run, false
  set :raise_errors, true
  set :logging, false

  RSpec.configure do |conf|
    conf.include Rack::Test::Methods
    conf.include Capybara::DSL
  end

  def app
    @app ||= Backend
  end
end

Spork.each_run do
end