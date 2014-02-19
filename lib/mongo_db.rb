require 'mongo'

include Mongo

class MongoDb

  def initialize
    host    = ENV["MONGO_HOST"] || "localhost"
    port    = ENV["MONGO_PORT"] || "27017"
    db_name = ENV["MONGO_DB_NAME"] || "dandb"

    @client = MongoClient.new(host, port).db(db_name)
    authenticate

    @client
  end

private

  def authenticate
    if (ENV["MONGO_USER"] && ENV["MONGO_PASSWORD"])
      @client.authenticate(ENV["MONGO_USER"], ENV["MONGO_PASSWORD"])
    end
  end
end
