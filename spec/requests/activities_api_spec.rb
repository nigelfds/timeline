require 'spec_helper'

username = 'admin'
password = 'admin'

db_activities = $db["activities"]
db_users = $db["users"]

describe "Activities API Spec" do

  describe "GET activities" do

    it "returns 401 when not authorised" do
      user_id = '52eeec750004deaf4d00000b'
      get "/users/#{user_id}/activities"
      last_response.status.should eq(401)
    end

    describe "when authorised" do

      before (:each) do
        authorize username, password
      end

      after(:each) do
        db_activities.remove
      end

      it "return an empty array" do
        user_id = '52eeec750004deaf4d00000b'

        get "/users/#{user_id}/activities"

        response = JSON.parse(last_response.body)
        response["activities"].should be_empty
      end

      it "returns all the users activities" do
        user_id = '52eeec750004deaf4d00000b'
        start = Time.now.utc
        db_activities.insert(:start => start, :description => "Activity 1", :user_id => BSON.ObjectId(user_id))
        db_activities.insert(:start => start, :description => "Activity 2", :user_id => BSON.ObjectId(user_id))
        db_activities.insert(:start => start, :description => "Other Activity 1", :user_id => "2")
        db_activities.insert(:start => start, :description => "Other Activity 2", :user_id => "2")

        get "/users/#{user_id}/activities"

        response = JSON.parse(last_response.body)

        activities = response["activities"]

        activities.length.should eql(2)

        activity = activities[0]
        activity["start"].should eql(start.to_s)
        activity["description"].should eql("Activity 1")

        activity = activities[1]
        activity["start"].should eql(start.to_s)
        activity["description"].should eql("Activity 2")
      end

      it "returns activities in start order" do
        user_id = '52eeec750004deaf4d00000b'
        start = Time.now.utc
        db_activities.insert(:start => start, :description => "Second", :user_id => BSON.ObjectId(user_id))
        db_activities.insert(:start => start + 1000, :description => "Third", :user_id => BSON.ObjectId(user_id))
        db_activities.insert(:start => start - 1000, :description => "First", :user_id => BSON.ObjectId(user_id))

        get "/users/#{user_id}/activities"

        response = JSON.parse(last_response.body)
        activities = response["activities"]

        activities[0]["description"].should eql("First")
        activities[1]["description"].should eql("Second")
        activities[2]["description"].should eql("Third")
      end
    end
  end

  describe "GET activity" do

    it "returns 401 when not authorised" do
      user_id = '52eeec750004deaf4d00000b'
      activity_id = "52eeec750004deaf4d00000c"

      get "/users/#{user_id}/activities/#{activity_id}"

      last_response.status.should eq(401)
    end

    describe "when authorised" do

      before (:each) do
        authorize username, password
      end

      after(:each) do
        db_activities.remove
      end

      it "returns the correct activity" do
        user_id = '52eeec750004deaf4d00000b'
        data = {:start => Time.now.utc,
            :description => "Some Event",
            :user_id => BSON.ObjectId(user_id)}
        activity_id = db_activities.insert(data)

        get "/users/#{user_id}/activities/#{activity_id}"

        response = JSON.parse(last_response.body)

        response["start"].should eql(data[:start].to_s)
        response["description"].should eql(data[:description])
      end

      it "does not return activities for wrong patient" do
        user_id = '52eeec750004deaf4d00000b'
        data = {:start => Time.now.utc,
            :description => "Some Event",
            :user_id => "another_user_id"}
        activity_id = db_activities.insert(data)

        get "/users/#{user_id}/activities/#{activity_id}"

        last_response.status.should eq(404)
      end
    end
  end

  describe "POST activity" do

    describe "when not authorised" do
      it "returns 401 when not authorised" do
        user_id = "52eeec750004deaf4d00000b"
        new_activity = {"activityType" => "Basis32"}

        post "/users/#{user_id}/activities", new_activity.to_json

        last_response.status.should eq(401)

        db_activities.find.to_a.should be_empty
      end
    end

    describe "when authorised" do

      before (:each) do
        authorize username, password

        @user_id = db_users.insert({"name" => "Justin"})

        @new_activity = { "activityType" => "Basis32" }
      end

      after(:each) do
        db_activities.remove
        db_users.remove
      end

      it "returns an OK response" do
        post "/users/#{@user_id}/activities", @new_activity.to_json

        last_response.status.should eq(200)
      end

      it "returns a newly created activity" do
        post "/users/#{@user_id}/activities", @new_activity.to_json

        response = JSON.parse(last_response.body)
        response_id = BSON.ObjectId(response["_id"]["$oid"])
        created_activity = db_activities.find_one("_id" => response_id)
        created_activity.should_not be_nil
      end

      it "sets the user correctly" do
        post "/users/#{@user_id}/activities", @new_activity.to_json

        response = JSON.parse(last_response.body)
        response_id = BSON.ObjectId(response["_id"]["$oid"])
        created_activity = db_activities.find_one("_id" => response_id)
        created_activity["user_id"].should eql(@user_id)
      end

      describe "with an invalid activity" do
        let(:activity) { {} }
        before { app.any_instance.should_receive(:is_valid_activity).with(activity).and_return(false) }

        it "returns an OK response" do
          post "/users/#{@user_id}/activities", activity.to_json

          last_response.status.should eq(400)
        end

        it "doesn't create a new activity" do
          post "/users/#{@user_id}/activities", activity.to_json

          db_activities.find.to_a.should be_empty
        end
      end

    end

    describe '#is_valid_activity' do
      xit 'should return true when ...' do
      end

      xit 'should return false when ...' do
      end
    end

  end



  describe "PUT activity" do

    before(:each) do
      @user_id = db_users.insert({"name" => "Justin"})
      @activity_id = db_activities.insert({"start" => Time.now.utc, "description" => "Something", "userId" => @user_id})
      @activity = db_activities.find_one(@activity_id)
    end

    after(:each) do
      db_activities.remove
    end

    it "should be return 401 when not authorised" do
      put "/users/#{@user_id}/activities/#{@activity_id}", @update.to_json

      last_response.status.should eq(401)
    end

    describe "when authorised" do

      before (:each) do
        authorize username, password
        @update = {"description" => "Something new"}
      end

      it "updates an activity" do
        put "/users/#{@user_id}/activities/#{@activity_id}", @update.to_json

        updated_activity = db_activities.find_one(@activity_id)

        updated_activity["start"].should eql(@activity["start"])
        updated_activity["description"].should eql(@update["description"])
        updated_activity["userId"].should eql(@activity["userId"])
      end

      it "returns an error if no activity exists" do
        non_existent_activity_id = "52eeec750004deaf4d00000b"

        put "/users/#{@user_id}/activities/#{non_existent_activity_id}", @update.to_json

        last_response.status.should eq(400)
      end

      it "returns an error if the user doesn't exist" do
        non_existent_user_id = "52eeec750004deaf4d00000b"

        put "/users/#{non_existent_user_id}/activities/#{@activity_id}", @update.to_json

        last_response.status.should eq(400)
      end

      # #TODO: check patient exists?
      # it "should update a event" do
      #   patient_id = '52eeec750004deaf4d00000b'
      #   time = Time.now.utc
      #   id = $db["events"].insert({:description => "Some Event", :start => time, :patient_id => BSON.ObjectId(patient_id)}).to_s
      #   put '/patient/'+patient_id+'/event/'+id, {:description => "Super Special Event", :start => (time + 1000).to_s}.to_json

      #   result = $db["events"].find_one(BSON.ObjectId(id))
      #   result.should_not be_nil
      #   result.should include("description" => "Super Special Event")
      #   result.should include("start" => (time + 1000).to_s)
      #   result.should include("patient_id" => BSON.ObjectId(patient_id))
      # end

      # it "should return error if update fails" do
      #   put '/patient/52eeec750004deaf4d00000b/event/52eeec750004deaf4d00000b', {:description => "Super Special Event", :start => 1}.to_json

      #   last_response.status.should eq(400)
      # end
    end
  end

  # describe "DELETE event" do

  #   it "should be return 401 when not authorised" do
  #     patient_id = '52eeec750004deaf4d00000b'
  #     id = '52eeec750004deaf4d00000c'
  #     delete "/patient/#{patient_id}/event/#{id}"
  #     last_response.status.should eq(401)
  #   end

  #   describe "when authorised" do

  #     before (:each) do
  #        authorize username, password
  #     end


  #     after(:each) do
  #       $db["events"].remove
  #     end

  #     it "should delete event" do
  #       patient_id = '52eeec750004deaf4d00000b'
  #       id = $db["events"].insert({:description => "Some Event", :start => Time.now.utc, :patient_id => BSON.ObjectId(patient_id)}).to_s
  #       raise "No event inserted" unless id
  #       delete '/patient/'+patient_id+'/event/'+id

  #       $db["events"].find_one(BSON.ObjectId(id)).should be_nil
  #     end

  #     it "return 404 if cannot find object to delete" do
  #       patient_id = id = '52eeec750004deaf4d00000b'

  #       delete '/patient/'+patient_id+'/event/'+id
  #       last_response.status.should eq(404)
  #     end
  #   end
  # end
end
