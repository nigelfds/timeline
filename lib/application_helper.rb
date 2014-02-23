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

end
