require "spec_helper"

db_users = $db["users"]
url_path = "/users"

username = 'admin'
password = 'admin'

describe "GET #{url_path}" do

	after(:each) do
		db_users.remove
	end

	it "should be return 401 when not authorised" do
		get "#{url_path}"
		last_response.status.should eq(401)
	end

	describe "when authorised" do

		before (:each) do
			 authorize username, password
		end

		it "should be json" do
			get "#{url_path}"

			last_response.headers["Content-Type"].should eq("application/json;charset=utf-8")
		end

		it "should get a empty list of customers" do
			get "#{url_path}"
			response = JSON.parse(last_response.body)

			response.should eql([])
		end

		it "should get a list of customers" do
			db_users.insert :name => "Bob"
			db_users.insert :name => "John"

			get "#{url_path}"
			response = JSON.parse(last_response.body)

			response.should have(2).items

			# JSON.parse(last_response.body)["users"][0].should include("name" => "Bob")
		end
	end
end

describe "GET #{url_path}/:id" do
	after(:each) do
		db_users.remove
	end

	it "should be return 401 when not authorised" do
		get "#{url_path}/52eeec750004deaf4d00000b"
		last_response.status.should eq(401)
	end

	describe "when authorised" do

		before (:each) do
			 authorize username, password
		end

		it "should return not found if no customer found" do
			get "#{url_path}/52eeec750004deaf4d00000b"
			last_response.status.should eq(404)
		end

		it "should get a user" do
			id = db_users.insert(:name => "Bob").to_s
			get "#{url_path}/#{id}"

			response = JSON.parse(last_response.body)

			response["name"].should eq("Bob")
		end
	end
end

describe "POST #{url_path}" do
	it "should be return 401 when not authorised" do
		new_user = {"name" => "Jack"}

		post "#{url_path}", new_user.to_json

		last_response.status.should eq(401)

		db_users.find_one("name"=>"Jack").should be_nil
	end

	describe "when authorised" do

		before (:each) do
			 authorize username, password
		end

		after(:each) do
			db_users.remove
		end

		it "should insert a new user" do
			new_user = {"name" => "Jack"}

			post "#{url_path}", new_user.to_json

			db_users.find_one("name"=>"Jack").should_not be_nil
		end

		it "should return a response of OK" do
			post "#{url_path}", {"name" => "Jack"}.to_json

			last_response.status.should eq(200)
		end

		it "should return the new user" do
			post "#{url_path}", {"name" => "Jack"}.to_json

			response = JSON.parse(last_response.body)
			response["name"].should eq("Jack")
		end

		describe "with an invalid request" do

			it "should return an error response" do
				post "#{url_path}", {}.to_json

				last_response.status.should eq(400)
			end

			it "should not insert a new user" do
				post "#{url_path}", {}.to_json

				db_users.find.to_a.should eq([])
			end

		end
	end

end

describe "PUT #{url_path}" do

	it "should be return 401 when not authorised" do
		update = {"name" => "Frank"}

		put "#{url_path}/52eeec750004deaf4d00000b", update.to_json
		last_response.status.should eq(401)
	end

	describe "when authorised" do

		before (:each) do
			 authorize username, password
		end

		after(:each) do
			db_users.remove
		end

		describe "with a valid update" do
			before(:each) do
				@id = db_users.insert(:name => "Fred")

			end

			it "should return an OK response" do
				update = {"name" => "Frank"}

				put "#{url_path}/#{@id}", update.to_json

				last_response.status.should eq(200)
			end

			it "should update the users name" do
				update = {"name" => "Frank"}

				put "#{url_path}/#{@id}", update.to_json

				user = db_users.find_one("_id" => @id)
				user["name"].should eq("Frank")
			end

		end


		it "should return error if update fails" do
			put "#{url_path}/52eeec750004deaf4d00000b", {"name" => "Frank"}.to_json

			last_response.status.should eq(400)
		end
	end
end
