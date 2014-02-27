module ApplicationHelper

  def protected!
    return if (ENV["PASSWORD_PROTECTED"]!="true" or authorized?)
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)

    username = ENV["USER_NAME"] || "admin"
    password = ENV["USER_PASSWORD"] || "admin"
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [username, password]
  end

  def db
    settings.mongo_db
  end

  def isValidUser patient
    patient["name"]
  end

  def is_valid_activity activity
    activity["date"] && activity["description"]
  end

  def db_error_message
    err_msg_map = {
      11000 => 'UR Number already exists',
      11001 => 'UR Number already exists'
    }
    err_msg_map.default = 'Internal Server Error'
    err_msg_map
  end

end
