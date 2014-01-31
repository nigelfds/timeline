require 'spec_helper'

describe "My Sinatra API" do

  it "should allow accessing the home page" do
    get '/'
    last_response.should be_ok
  end
end

describe "GET Patients" do
	it "should be json" do
		get '/patient'
		last_response.headers['Content-Type'].should eq('application/json;charset=utf-8')
	end

	it "should get a empty list of customers" do
		get '/patient'
		{:patients => []}.to_json.should eq(last_response.body)
	end
end

describe "POST Patient" do
	after(:each) do
		$db["patients"].remove
	end
	it "should get a list of customers" do
		$db["patients"].insert :name => "Bob"
		get '/patient'
		JSON.parse(last_response.body)["patients"][0].should include("name" => "Bob")
	end
	it "should add a patient" do
		post '/patient', {"name" => "Jack"}.to_json
		$db["patients"].find_one("name"=>"Jack").should include("name" => "Jack")
	end

	it "should give error on invalid patient creation request" do
		post '/patient', {}.to_json
		last_response.status.should eq(400)
		$db["patients"].find.to_a.should eq([])

	end
end