require 'spec_helper'

describe "Event API Spec" do
	
	describe "GET events" do
		after(:each) do
			$db["events"].remove
		end

		it "return an empty array" do
			get '/patient/1/event'
			(last_response.body).should eq({:events => []}.to_json)
		end

		it "return an array of events" do
			$db["events"].insert({:description => "Some Event", :start => Time.now.utc, :patient_id => "1"})
			get '/patient/1/event'
			JSON.parse(last_response.body)["events"][0].should include("description" => "Some Event")
		end

		it "return events related to the specified patient" do
			$db["events"].insert({:description => "Some Event", :start => Time.now.utc, :patient_id => "1"})
			$db["events"].insert({:description => "Last Event", :start => (Time.now + 1000).utc, :patient_id => "2"})
			$db["events"].insert({:description => "First Event", :start => (Time.now - 1000).utc, :patient_id => "3"})

			get '/patient/2/event'
			events = JSON.parse(last_response.body)["events"]
			events.size.should eq(1)
			events[0].should include("description" => "Last Event")
		end

		it "return an array of multiple events ordered by start time" do
			$db["events"].insert({:description => "Some Event", :start => Time.now.utc, :patient_id => "1"})
			$db["events"].insert({:description => "Last Event", :start => (Time.now + 1000).utc, :patient_id => "1"})
			$db["events"].insert({:description => "First Event", :start => (Time.now - 1000).utc, :patient_id => "1"})
			
			get '/patient/1/event'
			JSON.parse(last_response.body)["events"][0].should include("description" => "First Event")
			JSON.parse(last_response.body)["events"][1].should include("description" => "Some Event")
			JSON.parse(last_response.body)["events"][2].should include("description" => "Last Event")
		end
	end
end