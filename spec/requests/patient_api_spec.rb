require 'spec_helper'

describe "GET Patients" do
	after(:each) do
		$db["patients"].remove
	end
	it "should be json" do
		get '/patient'
		last_response.headers['Content-Type'].should eq('application/json;charset=utf-8')
	end

	it "should get a empty list of customers" do
		get '/patient'
		{:patients => []}.to_json.should eq(last_response.body)
	end
	it "should get a list of customers" do
		$db["patients"].insert :name => "Bob"
		get '/patient'
		JSON.parse(last_response.body)["patients"][0].should include("name" => "Bob")
	end
end

describe "GET Patient" do
	after(:each) do
		$db["patients"].remove
	end

	it "should return not found if no customer found" do
		get '/patient/'+'52eeec750004deaf4d00000b'
		last_response.status.should eq(404)
	end
	it "should get a customer" do
		id = $db["patients"].insert(:name => "Bob").to_s
		get '/patient/'+id
		JSON.parse(last_response.body)["patient"].should include("name" => "Bob")
	end
end

describe "POST Patient" do
	after(:each) do
		$db["patients"].remove
	end

	it "should add a patient" do
		post '/patient', {"name" => "Jack"}.to_json

		last_response.status.should eq(200)
		last_response.body.should_not be_empty  #Return id
		$db["patients"].find_one("name"=>"Jack").should include("name" => "Jack")
	end

	it 'should return the new patient' do
		post '/patient', {"name" => "Jack"}.to_json

		last_response.body.should include('"name":"Jack"')
	end

	it "should give error on invalid patient creation request" do
		post '/patient', {}.to_json
		last_response.status.should eq(400)
		$db["patients"].find.to_a.should eq([])
	end
end

describe "PUT Patient" do
	after(:each) do
		$db["patients"].remove
	end

	it "should update the patients name" do
		id = $db["patients"].insert(:name => "Fred").to_s
		put '/patient/'+id, {"name" => "Frank"}.to_json

		last_response.status.should eq(200)

		$db["patients"].find_one("name"=>"Frank").should include("name" => "Frank")
		$db["patients"].find_one("name"=>"Fred").should be_nil
	end

	it "should return error if update fails" do
		put '/patient/52eeec750004deaf4d00000b', {"name" => "Frank"}.to_json

		last_response.status.should eq(400)
	end
end
