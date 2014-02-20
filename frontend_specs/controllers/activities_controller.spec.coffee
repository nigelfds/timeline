describe "ActivitiesController", ->
  scope = routeParams = activitiesService = undefined
  userId = "the-user-id"
  activities = ["1", "2"]

  beforeEach module("timeline")

  beforeEach inject (_$rootScope_) ->
    scope = _$rootScope_.$new()
    routeParams = userId: userId

  beforeEach ->
    activitiesService = sinon.createStubInstance ActivitiesService
    activitiesService.getActivities.withArgs(userId).yields activities


  it "displays all the activities", ->
    ActivitiesController scope, routeParams, activitiesService

    scope.activities.should.eql activities

  it "selects the first activity by default", ->
    ActivitiesController scope, routeParams, activitiesService

    scope.selectedActivity.should.eql activities[0]

  describe "selecting an activity", ->

    it "displays the selected activity", ->
      ActivitiesController scope, routeParams, activitiesService

      scope.select(1)

      scope.selectedActivity.should.eql activities[1]

  describe "saving the selected activity", ->

    it "sends an update to the service", ->
      activityId = "the-activity-id"
      values = date: "the-date-of-the-activity", description: "the description of the activity"
      activitiesService.updateActivity.withArgs(userId, activityId).yields true
      ActivitiesController scope, routeParams, activitiesService

      scope.selectedActivity = 
        "_id": "$oid": activityId
        "date": values.date
        "description": values.description
        "user_id": "$oid": userId
      scope.save()

      activitiesService.updateActivity.should.have.been.calledWith(userId, activityId, values)
