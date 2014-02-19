require 'sinatra'
require 'sinatra/base'

require_relative 'lib/mongo_db'

ENV["USER_NAME"] = "admin" unless ENV["USER_NAME"]
ENV["USER_PASSWORD"] = "admin" unless ENV["USER_PASSWORD"]
ENV["PASSWORD_PROTECTED"] = "false" unless ENV["PASSWORD_PROTECTED"]

class Backend < Sinatra::Base

  def initialize db=nil
    super()
    @db = db || MongoDb.new
  end

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

  get '/users' do
    content_type :json

    users = @db["users"].find.to_a

    users.to_json
  end

  get '/users/:id' do
    content_type :json
    patient = @db["users"].find_one({"_id" => BSON.ObjectId(params[:id])})
    if patient
      patient.to_json
    else
      error 404
    end
  end

  post '/users' do
    body = JSON.parse(request.body.read)
    if isValidUser(body)
      id = @db["users"].insert(body).to_s
      body(@db["users"].find_one({"_id" => BSON.ObjectId(id)}).to_json)
      status 200
    else
      error 400
    end
  end

  put '/users/:id' do
    id = BSON.ObjectId(params[:id])
    new_values = JSON.parse(request.body.read)

    result = @db["users"].update({"_id" => id}, {"$set" => new_values})

    unless result["updatedExisting"]
      error 400, result.to_json
    end
  end

  def isValidUser(patient)
    patient["name"]
  end

  # get '/activities/:activityId' do

  # end

  # post '/activities' do
  #   body = JSON.parse(request.body.read)

  #   if is_valid_activity(body)
  #     body["start"] = Time.now.utc
  #     id = @db["activities"].insert(body)
  #     activity = @db["activities"].find_one("_id" => id)
  #     body(activity.to_json)
  #   else
  #     error 400
  #   end
  # end

  # def is_valid_activity(activity)
  #   activity["activityType"]
  # end

  # ==============================================================================================

  get '/users/:user_id/activities' do
    content_type :json
    activities = @db["activities"].find(:user_id => BSON.ObjectId(params[:user_id])).sort(:start).to_a
    { :activities => activities }.to_json
  end

  get '/users/:user_id/activities/:activity_id' do
    content_type :json
    query = {
      "_id" => BSON.ObjectId(params[:activity_id]),
      "user_id" => BSON.ObjectId(params[:user_id])
    }

    activity = @db["activities"].find_one(query)

    if activity
      activity.to_json
    else
      error 404
    end
  end

  post '/users/:user_id/activities' do
    new_data = JSON.parse(request.body.read)

    if is_valid_activity(new_data)
      new_data = new_data.merge(:user_id => BSON.ObjectId(params[:user_id]))
      id = @db["activities"].insert(new_data)

      activity = @db["activities"].find_one("_id" => id)
      activity.to_json
    else
      error 400
    end
  end

  put '/users/:user_id/activities/:activity_id' do
    user = @db["users"].find_one(BSON.ObjectId(params[:user_id]))
    return error 400 if user.nil?

    update_data = JSON.parse(request.body.read)
    result = @db["activities"].update({"_id" => BSON.ObjectId(params[:activity_id])}, '$set' => update_data)
    error 400 unless result["updatedExisting"]
  end

  def is_valid_activity(activity)
    return false if activity.empty?
    # activity["activityType"]
    true
  end

  # delete '/patient/:patient_id/event/:id' do
  #   result = @db["events"].remove("_id" => BSON.ObjectId(params[:id]))
  #   if result["n"] > 0
  #     status 200
  #   else
  #     error 404
  #   end
  # end

  # def isValidEvent(event)
  #   event["description"] && event["start"] #Note patient_id is already coming through as part of the url...
  # end

end
