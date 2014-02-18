describe "ActivityService", ->

	service = $httpBackend = undefined

	beforeEach module "timeline"

	beforeEach inject (_ActivityService_, _$httpBackend_) ->
		service = _ActivityService_
		$httpBackend = _$httpBackend_

	describe "getActivity", ->
		it "returns the correct activity",  ->
			activityId = "some_activity_id"
			existing_activity = {id: "12345", activityType: "Basis32"}		
			$httpBackend.whenGET("/activities/#{activityId}").respond existing_activity

			service.getActivity activityId, (activity) ->
				activity.should.eql	existing_activity

			$httpBackend.flush()
		

	describe "createActivity", ->

		it "create a new activity", ->
			data = {activityType: "Basis32"}
			created_activity = {id: "12345", activityType: "Basis32"}
			$httpBackend.whenPOST("/activities", data).respond created_activity

			service.createActivity data, (new_activity) -> new_activity.should.eql created_activity

			$httpBackend.flush()
