require 'rubygems'
require 'spork'

ENV['RACK_ENV'] = 'test'  # force the environment to 'test'
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
    conf.include ApplicationHelper

    conf.before(:each) { Backend.any_instance.stub(:db).and_return(test_db) }
  end

  def test_db
    client = MongoClient.new('localhost', 27017).db('TestDb')
    #TODO: should have better way to do test for uniqueness, instead of indexing test db
    client["users"].ensure_index( { :urNumber => Mongo::ASCENDING }, { :unique => true, :sparse => true} )
    client
  end

  def app
    @app ||= Backend.new
  end
end

Spork.each_run do
end
