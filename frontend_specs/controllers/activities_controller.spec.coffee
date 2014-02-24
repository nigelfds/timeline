describe "ActivitiesController", ->
  scope = routeParams = timeout = activitiesService = usersService = undefined
  userId = "the-user-id"
  activities = ["1", "2"]
  activityId = values = currentUser = undefined

  beforeEach module("timeline")

  beforeEach inject (_$rootScope_) ->
    scope = _$rootScope_.$new()
    routeParams = userId: userId

  beforeEach ->
    activitiesService = sinon.createStubInstance ActivitiesService
    activitiesService.getActivities.withArgs(userId).yields activities
    activityId = "the-activity-id"
    values = date: "the-date-of-the-activity", description: "the description of the activity"
    activitiesService.updateActivity.withArgs(userId, activityId).yields true

    usersService = sinon.createStubInstance UsersService
    currentUser = name: "Pei Shi", urNumber: "243342342345"
    usersService.getUser.withArgs(userId).yields currentUser

    timeout = sinon.stub()

    ActivitiesController scope, routeParams, timeout, activitiesService, usersService

  it "displays the users details", ->
    scope.user.should.eql currentUser

  it "displays all the activities", ->
    scope.activities.should.eql activities

  it "selects the first activity by default", ->
    scope.selectedActivity.should.eql activities[0]

  describe "selecting an activity", ->

    it "displays the selected activity", ->
      scope.select activities[1]

      scope.selectedActivity.should.eql activities[1]

  describe "adding a new activity", ->
    new_activity = default_values = undefined

    beforeEach ->
      now = "01/01/2014 02:00 PM"
      Date.now = sinon.stub()
      Date.now.returns new Date(now).getTime()
      default_values =
        date: now,
        description: "New Activity"
      new_activity = "new-activity"
      activitiesService.createActivity.withArgs(userId, default_values).yields new_activity


    it "displays the new activity", ->
      scope.new()

      scope.activities.should.contain new_activity

    it "selected the new activity", ->
      scope.new()

      scope.selectedActivity.should.eql new_activity

  describe "saving the selected activity", ->

    beforeEach ->
      scope.selectedActivity = 
        "_id": "$oid": activityId
        "date": values.date
        "description": values.description
        "user_id": "$oid": userId

    it "sends an update to the service", ->
      scope.save()
      activitiesService.updateActivity.should.have.been.calledWith(userId, activityId, values)

    it "alerts on success", ->
      scope.save()
      scope.alerts[0].should.eql "Updated successfully"

    it "removes alerts after a timeout", ->
      timeout.withArgs(sinon.match.func, 5000).yields()

      scope.save()

      scope.alerts.should.be.empty

  describe "removing an activity", ->
    selectedActivity = undefined
    beforeEach ->
      selectedActivity =
        "_id": "$oid": activityId
        "date": values.date
        "description": values.description
        "user_id": "$oid": userId
      scope.selectedActivity = selectedActivity
      activities.push selectedActivity
      activitiesService.deleteActivity.withArgs(userId, activityId).yields true

    it "removes the activity", ->
      scope.delete()
      scope.activities.should.not.contain selectedActivity

    it "unselects the activity", ->
      scope.delete()
      expect(scope.selectedActivity).to.eql undefined