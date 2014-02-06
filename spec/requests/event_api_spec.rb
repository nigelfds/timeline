require 'spec_helper'

describe "Event API Spec" do

	describe "GET events" do
		after(:each) do
			$db["events"].remove
		end

		it "return an empty array" do
			patient_id = '52eeec750004deaf4d00000b'
			get '/patient/'+patient_id+'/event'
			(last_response.body).should eq({:events => []}.to_json)
		end

		it "return an array of events" do
			patient_id = '52eeec750004deaf4d00000b'
			$db["events"].insert({:description => "Some Event", :start => Time.now.utc, :patient_id => BSON.ObjectId(patient_id)})
			get '/patient/'+patient_id+'/event'
			JSON.parse(last_response.body)["events"][0].should include("description" => "Some Event")
		end

		it "return events related to the specified patient" do
			patient_id = '52eeec750004deaf4d00000b'
			$db["events"].insert({:description => "Some Event", :start => Time.now.utc, :patient_id => "1"})
			$db["events"].insert({:description => "Last Event", :start => (Time.now + 1000).utc, :patient_id => BSON.ObjectId(patient_id)})
			$db["events"].insert({:description => "First Event", :start => (Time.now - 1000).utc, :patient_id => "3"})

			get '/patient/'+patient_id+'/event'
			events = JSON.parse(last_response.body)["events"]
			events.size.should eq(1)
			events[0].should include("description" => "Last Event")
		end

		it "return an array of multiple events ordered by start time" do
			patient_id = '52eeec750004deaf4d00000b'
			$db["events"].insert({:description => "Some Event", :start => Time.now.utc, :patient_id => BSON.ObjectId(patient_id)})
			$db["events"].insert({:description => "Last Event", :start => (Time.now + 1000).utc, :patient_id => BSON.ObjectId(patient_id)})
			$db["events"].insert({:description => "First Event", :start => (Time.now - 1000).utc, :patient_id => BSON.ObjectId(patient_id)})

			get '/patient/'+patient_id+'/event'
			JSON.parse(last_response.body)["events"][0].should include("description" => "First Event")
			JSON.parse(last_response.body)["events"][1].should include("description" => "Some Event")
			JSON.parse(last_response.body)["events"][2].should include("description" => "Last Event")
		end
	end

	describe "GET event" do
		after(:each) do
			$db["events"].remove
		end

		it "should return event" do
			patient_id = '52eeec750004deaf4d00000b'
			id = $db["events"].insert({:description => "Some Event", :start => Time.now.utc, :patient_id => BSON.ObjectId(patient_id)}).to_s
			get '/patient/'+patient_id+'/event/'+id
			JSON.parse(last_response.body)["event"].should include("description" => "Some Event")
		end

		it "should not return event for wrong patient" do
			patient_id = '52eeec750004deaf4d00000b'
			id = $db["events"].insert({:description => "Some Event", :start => Time.now.utc, :patient_id => "2"}).to_s
			get '/patient/'+patient_id+'/event/'+id

			last_response.status.should eq(404)
		end
	end

	describe "POST event" do
		after(:each) do
			$db["events"].remove
		end
		#TODO: check patient exists?
		it "should create an event" do
			patient_id = '52eeec750004deaf4d00000b'
			time = Time.now.utc.to_s
			post '/patient/'+patient_id+'/event', {:description => "Special Event", :start => time}.to_json

			last_response.status.should eq(200)
			last_response.body.should_not be_empty  #Return id

			result = $db["events"].find_one("description" => "Special Event")
			result.should_not be_nil
			result.should include("description" => "Special Event")
			result.should include("start" => time)
			result.should include("patient_id" => BSON.ObjectId(patient_id))
		end

		it "should fail if invalid data" do
			patient_id = '52eeec750004deaf4d00000b'
			time = Time.now.utc.to_s
			post '/patient/'+patient_id+'/event', {}.to_json

			last_response.status.should eq(400)
			$db["events"].find.to_a.should eq([])
		end

		it 'should return the event' do
			patient_id = '52eeec750004deaf4d00000b'
			time = Time.now.utc.to_s
			post '/patient/'+patient_id+'/event', {:description => "Special Event", :start => time}.to_json

			last_response.body.should include('"description":"Special Event"')
			last_response.body.should include(time)
		end
	end

	describe "PUT event" do
		after(:each) do
			$db["events"].remove
		end

		#TODO: check patient exists?
		it "should update a event" do
			patient_id = '52eeec750004deaf4d00000b'
			time = Time.now.utc
			id = $db["events"].insert({:description => "Some Event", :start => time, :patient_id => BSON.ObjectId(patient_id)}).to_s
			put '/patient/'+patient_id+'/event/'+id, {:description => "Super Special Event", :start => (time + 1000).to_s}.to_json

			result = $db["events"].find_one(BSON.ObjectId(id))
			result.should_not be_nil
			result.should include("description" => "Super Special Event")
			result.should include("start" => (time + 1000).to_s)
			result.should include("patient_id" => BSON.ObjectId(patient_id))
		end

		it "should return error if update fails" do
			put '/patient/52eeec750004deaf4d00000b/event/52eeec750004deaf4d00000b', {:description => "Super Special Event", :start => 1}.to_json

			last_response.status.should eq(400)
		end
	end

	describe "DELETE event" do
		after(:each) do
			$db["events"].remove
		end

		it "should delete event" do
			patient_id = '52eeec750004deaf4d00000b'
			id = $db["events"].insert({:description => "Some Event", :start => Time.now.utc, :patient_id => BSON.ObjectId(patient_id)}).to_s
			raise "No event inserted" unless id
			delete '/patient/'+patient_id+'/event/'+id

			$db["events"].find_one(BSON.ObjectId(id)).should be_nil
		end

		it "return 404 if cannot find object to delete" do
			patient_id = id = '52eeec750004deaf4d00000b'

			delete '/patient/'+patient_id+'/event/'+id
			last_response.status.should eq(404)
		end
	end

end