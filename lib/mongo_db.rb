require 'mongo'

include Mongo

class MongoDb

  def self.client
    host    = ENV["MONGO_HOST"] || "localhost"
    port    = ENV["MONGO_PORT"] || "27017"
    db_name = ENV["MONGO_DB_NAME"] || "dandb"

    client = MongoClient.new(host, port).db(db_name)
    authenticate client

    client["users"].ensure_index( { :urNumber => Mongo::ASCENDING }, { :unique => true, :sparse => true} )

    client
  end

private

  def self.authenticate client
    if (ENV["MONGO_USER"] && ENV["MONGO_PASSWORD"])
      client.authenticate(ENV["MONGO_USER"], ENV["MONGO_PASSWORD"])
    end
  end
end
