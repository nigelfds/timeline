require 'date'
require_relative 'lib/mongo_db'

db = MongoDb.client

users = db["users"]
users.remove

activities = db["activities"]
activities.remove

(1..100).each do |i|
  puts "Entering data for User #{i}"
  id = users.insert :name => "User #{i}", :urNumber => "%08d" % i, :age => 21 + i % 30, :gender => "female"

  start_date = Date.parse("1 Jan 2013")
  end_date = Date.parse("31 Dec 2013")
  start_date.step(end_date, 3) do |date|
    d = date.strftime("%d/%m/%Y 12:00 AM")
    activities.insert :date => d, :description => d, :user_id => id

  end

end