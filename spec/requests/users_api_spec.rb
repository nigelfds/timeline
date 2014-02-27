require "spec_helper"

describe 'User API' do
  let(:url_path) { '/users' }
  let(:username) { 'admin' }
  let(:password) { 'admin' }

  let(:db_users) { test_db["users"] }

  after(:each) do
    db_users.remove
  end

  describe "GET /users" do

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

      context 'has users' do
        before do
          db_users.insert :name => "Bob"
          db_users.insert :name => "John"
        end

        it "should get a list of customers" do
          get "#{url_path}"
          response = JSON.parse(last_response.body)
          response.should have(2).items
          # JSON.parse(last_response.body)["users"][0].should include("name" => "Bob")
        end
      end
    end
  end

  describe "GET /users/:id" do
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

  describe "POST /users" do

    it "should be return 401 when not authorised" do
      post "#{url_path}", {"name" => "Jack"}.to_json

      last_response.status.should eq(401)
      db_users.find_one("name"=>"Jack").should be_nil
    end

    describe "when authorised" do
      let(:new_user) { {"name" => "Jack"} }

      before (:each) do
         authorize username, password
      end

      it "should insert a new user" do
        post "#{url_path}", new_user.to_json
        db_users.find_one("name"=>"Jack").should_not be_nil
      end

      it "should return a response of OK" do
        post "#{url_path}", new_user.to_json
        last_response.status.should eq(200)
      end

      it "should return the new user" do
        post "#{url_path}", new_user.to_json

        response = JSON.parse(last_response.body)
        response["name"].should eq("Jack")
      end

      describe "with an invalid request" do
        let(:new_user) { {} }

        it "should return an error response" do
          post "#{url_path}", new_user.to_json
          last_response.status.should eq(400)
        end

        it "should not insert a new user" do
          post "#{url_path}", new_user.to_json
          db_users.find.to_a.should eq([])
        end
      end

      describe "duplicated UR number" do
        let(:ur_num) { '007' }
        let(:existing_user) { {:name => "Bob", :urNumber => ur_num} }
        let(:new_user) { {:name => "Lily", :urNumber => ur_num} }

        before { db_users.insert existing_user}

        it "should return error response" do
          post "#{url_path}", new_user.to_json
          last_response.status.should eq(500)
          last_response.body.should eq("UR Number already exists")
        end

        it "should not insert the new user" do
          post "#{url_path}", new_user.to_json
          db_users.find.to_a.length.should eq 1
          db_users.find.to_a.first['name'].should eq 'Bob'
        end
      end
    end

  end

  describe "PUT /users" do
    let(:update_name) { {"name" => "Frank"} }

    it "should be return 401 when not authorised" do
      update = {"name" => "Frank"}

      put "#{url_path}/52eeec750004deaf4d00000b", update.to_json
      last_response.status.should eq(401)
    end

    describe "when authorised" do
      before (:each) do
         authorize username, password
      end

      describe "with a valid update" do
        before(:each) do
          @id = db_users.insert(:name => "Fred")
        end

        it "should return an OK response" do
          put "#{url_path}/#{@id}", update_name.to_json
          last_response.status.should eq(200)
        end

        it "should update only the supplied fields" do
          update = { "handovers" => 45, "contacts" => 68 }

          put "#{url_path}/#{@id}", update.to_json

          user = db_users.find_one("_id" => @id)
          user["name"].should eq("Fred")
          user["handovers"].should eq(45)
          user["contacts"].should eq(68)
        end

        it "should update the users name" do
          put "#{url_path}/#{@id}", update_name.to_json

          user = db_users.find_one("_id" => @id)
          user["name"].should eq("Frank")
        end
      end

      it "should return error if update fails" do
        put "#{url_path}/52eeec750004deaf4d00000b", update_name.to_json
        last_response.status.should eq(400)
      end

      describe "duplicated UR number" do
        let(:user1_ur_num) { '007' }
        let(:user1) { {:name => "Bob", :urNumber => user1_ur_num} }
        let(:user2_id) { 
          user2 = {:name => "Lily", :urNumber => '008' }
          db_users.insert user2
        }

        before do
          db_users.insert user1
          put "#{url_path}/#{user2_id}", { "urNumber" => user1_ur_num }.to_json
        end

        it "should return error response" do
          last_response.status.should eq(500)
          last_response.body.should eq("UR Number already exists")
        end

        it "should not update the user ur number" do
          user2 = db_users.find_one("_id" => user2_id)
          user2['urNumber'].should eq '008'
        end
      end
    end
  end
end
