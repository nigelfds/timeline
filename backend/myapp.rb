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

get '/patient/:id' do
	content_type :json
	patient = $db["patients"].find_one({"_id" => BSON.ObjectId(params[:id])})
	if patient
		{:patient => patient}.to_json
	else
		error 404
	end
end

post '/patient' do
	body = JSON.parse(request.body.read)
	if isValidPatient(body)
		id = $db["patients"].insert(:name => body["name"]).to_s
		body(id)
		status 200
	else
		error 400
	end
end

put '/patient/:id' do
	body = JSON.parse(request.body.read)
	new_values = body.select {|k,v| ["name"].include? k}
	result = $db["patients"].update({"_id" => BSON.ObjectId(params[:id])}, new_values)

	unless result["updatedExisting"]
		error 400, result.to_json
	end
end


def isValidPatient(patient)
	patient["name"]
end

get '/patient/:id/event' do
	content_type :json
	events = $db["events"].find(:patient_id => params[:id]).sort(:start).to_a
	{:events => events}.to_json
end

get '/patient/:patient_id/event/:id' do
	content_type :json
	event = $db["events"].find_one({"_id" => BSON.ObjectId(params[:id]), "patient_id" => BSON.ObjectId(params[:patient_id])})
	if event
		{:event => event}.to_json
	else
		error 404
	end
end

post '/patient/:patient_id/event' do
	body = JSON.parse(request.body.read)
	if isValidEvent(body)
		id = $db["events"].insert({:description => body["description"], :patient_id => params[:patient_id], :start => body["start"]}).to_s
		body(id)
		status 200
	else
		error 400
	end
end

put '/patient/:patient_id/event/:id' do
	body = JSON.parse(request.body.read)
	new_values = body.select {|k,v| ["description","start"].include? k}
	result = $db["events"].update({"_id" => BSON.ObjectId(params[:id])}, new_values)

	unless result["updatedExisting"]
		error 400, result.to_json
	end
end

delete '/patient/:patient_id/event/:id' do
	result = $db["events"].remove("_id" => BSON.ObjectId(params[:id]))
	if result["n"] > 0
		status 200
	else
		error 404
	end
end

def isValidEvent(event)
	event["description"] && event["start"] #Note patient_id is already coming through as part of the url...
end