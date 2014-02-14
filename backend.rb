require 'sinatra'
require 'sinatra/base'
require 'mongo'

include Mongo

ENV["MONGO_HOST"] = "localhost" unless ENV["MONGO_HOST"]
ENV["MONGO_PORT"] = "27017" unless ENV["MONGO_PORT"]
ENV["MONGO_DB_NAME"] = "dandb" unless ENV["MONGO_DB_NAME"]

ENV["USER_NAME"] = "admin" unless ENV["USER_NAME"]
ENV["USER_PASSWORD"] = "admin" unless ENV["USER_PASSWORD"]

ENV["PASSWORD_PROTECTED"] = "false" unless ENV["PASSWORD_PROTECTED"]

class Backend < Sinatra::Base

	helpers do
	  	def protected!
	    	return if (ENV["PASSWORD_PROTECTED"]!="true" or authorized?)
	    	headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
	    	halt 401, "Not authorized\n"
	  	end

	  	def authorized?
	    	@auth ||=  Rack::Auth::Basic::Request.new(request.env)
	    	@auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [ENV["USER_NAME"], ENV["USER_PASSWORD"]]
	  	end
	end

	before do
		protected!
	end

	$db = MongoClient.new(ENV["MONGO_HOST"], ENV["MONGO_PORT"]).db(ENV["MONGO_DB_NAME"])

	if (ENV["MONGO_USER"] and ENV["MONGO_PASSWORD"])
		$db.authenticate(ENV["MONGO_USER"], ENV["MONGO_PASSWORD"])
	end

	get '/users' do
		content_type :json

		users = $db["users"].find.to_a

		users.to_json
	end

	get '/users/:id' do
		content_type :json
		patient = $db["users"].find_one({"_id" => BSON.ObjectId(params[:id])})
		if patient
			patient.to_json
		else
			error 404
		end
	end

	post '/users' do
		body = JSON.parse(request.body.read)
		if isValidPatient(body)
			id = $db["users"].insert(body).to_s
			body($db["users"].find_one({"_id" => BSON.ObjectId(id)}).to_json)
			status 200
		else
			error 400
		end
	end

	put '/users/:id' do
		id = BSON.ObjectId(params[:id])
		new_values = JSON.parse(request.body.read)

		result = $db["users"].update({"_id" => id}, {"$set" => new_values})

		unless result["updatedExisting"]
			error 400, result.to_json
		end
	end


	def isValidPatient(patient)
		patient["name"]
	end

	get '/patient/:id/event' do
		content_type :json
		events = $db["events"].find(:patient_id => BSON.ObjectId(params[:id])).sort(:start).to_a
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
			id = $db["events"].insert({:description => body["description"], :patient_id => BSON.ObjectId(params[:patient_id]), :start => body["start"]}).to_s
			body($db["events"].find_one({"_id" => BSON.ObjectId(id)}).to_json)
			status 200
		else
			error 400
		end
	end

	put '/patient/:patient_id/event/:id' do
		body = JSON.parse(request.body.read)
		new_values = body.select {|k,v| ["description","start"].include? k}
		result = $db["events"].update({"_id" => BSON.ObjectId(params[:id])}, '$set' => new_values)

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

end