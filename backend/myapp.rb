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
	if isValidPatient(body)
		$db["patients"].insert :name => body["name"]
		status 200
	end
	error 400
end

def isValidPatient(patient)
	patient["name"]
end

get '/patient/:id/event' do
	content_type :json
	{:events => $db["events"].find(:patient_id => params[:id]).to_a}.to_json
end