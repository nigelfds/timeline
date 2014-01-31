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
	end
end