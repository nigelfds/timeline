require 'sinatra'
require 'sinatra/base'
require 'csv'

require_relative 'lib/mongo_db'
require_relative 'lib/application_helper'
require_relative 'lib/csv_export'

class Backend < Sinatra::Base
  helpers ApplicationHelper

  configure do
    set :mongo_db, MongoDb.client
  end

  before do
    protected!
  end

  get '/users' do
    content_type :json
    db["users"].find.to_a.to_json
  end

  get '/users/:id' do
    content_type :json

    patient = db["users"].find_one({"_id" => BSON.ObjectId(params[:id])})
    if patient
      patient.to_json
    else
      error 404
    end
  end

  post '/users' do
    body = JSON.parse(request.body.read)
    halt 400, 'Invalid user details entered' unless isValidUser(body)

    begin
      id = db["users"].insert(body).to_s
      body(db["users"].find_one({"_id" => BSON.ObjectId(id)}).to_json)
      status 200
    rescue => err
      halt 500, db_error_message[err.error_code]
    end
  end

  put '/users/:id' do
    begin
      id = BSON.ObjectId(params[:id])
      new_values = JSON.parse(request.body.read)
      result = db["users"].update({"_id" => id}, {"$set" => new_values})
      error 400, 'Failed to update user' unless result["updatedExisting"]
    rescue => err
      halt 500, db_error_message[err.error_code]
    end
  end

  # ==============================================================================================

  get '/users/:user_id/activities' do
    content_type :json
    activities = db["activities"].find(:user_id => BSON.ObjectId(params[:user_id])).sort(:start).to_a
    activities.to_json
  end

  get '/users/:user_id/activities/:activity_id' do
    content_type :json
    query = {
      "_id" => BSON.ObjectId(params[:activity_id]),
      "user_id" => BSON.ObjectId(params[:user_id])
    }

    activity = db["activities"].find_one(query)

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
      id = db["activities"].insert(new_data)

      activity = db["activities"].find_one("_id" => id)
      activity.to_json
    else
      error 400
    end
  end

  put '/users/:user_id/activities/:activity_id' do
    user = db["users"].find_one(BSON.ObjectId(params[:user_id]))
    return error 400 if user.nil?

    update_data = JSON.parse(request.body.read)

    activity_id = BSON.ObjectId(params[:activity_id])
    result = db["activities"].update({ :_id => activity_id }, '$set' => update_data)
    error 400 unless result["updatedExisting"]
  end

  delete '/users/:user_id/activities/:activity_id' do
    user = db["users"].find_one(BSON.ObjectId(params[:user_id]))
    return error 404 if user.nil?

    activity_id = BSON.ObjectId(params[:activity_id])
    result = db["activities"].remove(:_id => activity_id)

    return error 404 if result["n"] != 1
  end

  get '/download' do
    filename = 'data'
    temp_file = Tempfile.new([filename, '.csv']).path

    CSV.open( temp_file, 'w', :write_headers => true, :headers => csv_header ) do |csv|
      db['users'].find().each do |user|
        csv << data_for(user)
      end
    end

    send_file(temp_file, :disposition => 'attachment', :filename => filename)
  end

end
