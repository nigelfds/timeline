describe "ActivityController", ->

	scope = routeParams = undefined

	beforeEach ->
		scope = {}
		routeParams =
			userId: "something"
			activityType: "activity-type"

		ActivityController scope, routeParams

	it "sets the activity type", ->

		scope.activityType.should.eql "activity-type"
