require 'spec_helper'

describe "My Sinatra API" do

  it "should allow accessing the home page" do
    get '/'
    last_response.should be_ok
  end
end

describe "Patients" do
	it "should be json" do
		get '/patient'
		last_response.headers['Content-Type'].should eq('application/json;charset=utf-8')
	end

	it "should get a empty list of customers" do
		get '/patient'
		{:patients => []}.to_json.should eq(last_response.body)
	end

	describe "Real patients" do
		after(:each) do
			$db["patients"].remove
		end
		it "should get a list of customers" do
			$db["patients"].insert :name => "Bob"
			get '/patient'
			JSON.parse(last_response.body)["patients"][0].should include("name" => "Bob")
		end
	end

	

end