describe "ActivityController", ->

  scope = routeParams = service = undefined

  beforeEach ->
    scope = {}
    routeParams =
      userId: "user-id"
      activityId: "activity-id"

    activity =
      "activityType": "activity-type"

    activityService = sinon.createStubInstance ActivityService
    activityService.getActivity.withArgs("activity-id").yields activity

    ActivityController scope, routeParams, activityService

  it "shows the correct activity type", ->
    scope.activityType.should.eql "activity-type"
