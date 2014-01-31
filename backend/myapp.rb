require 'sinatra'
require 'mongo'

include Mongo

$db = MongoClient.new("localhost", 27017).db("dandb")

get '/' do
  'Hello World'
end

get '/patient' do
	content_type :json
	{:patients => $db["patients"].find.to_a}.to_json
end

post '/patient' do
	body = JSON.parse(request.body.read)
	$db["patients"].insert("name" => body["name"])
end


