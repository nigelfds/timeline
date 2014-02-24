describe "ActivitiesController", ->
  scope = routeParams = timeout = activitiesService = usersService = undefined
  userId = "the-user-id"
  activityId = values = currentUser = undefined

  firstActivity = date: "11/11/2011 02:55 PM", description: "Some description", isAPM: true
  secondActivity = date: "12/11/2011 03:55 PM", description: "Some other description", isAPM: false
  activities = [ firstActivity, secondActivity ]


  beforeEach module("timeline")

  beforeEach inject (_$rootScope_) ->
    scope = _$rootScope_.$new()
    routeParams = userId: userId

  beforeEach ->
    activitiesService = sinon.createStubInstance ActivitiesService
    activitiesService.getActivities.withArgs(userId).yields activities
    activityId = "the-activity-id"
    values = date: "the-date-of-the-activity", description: "the description of the activity", involveHandoff: true
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

  describe "number of handsoff", ->

    it "display the total number of handoffs when there is any", ->
      fake_activities = [
        { date: "date", description: "play with kitty", involveHandoff: true },
        { date: "date", description: "feed ferrets",    involveHandoff: no },
        { date: "date", description: "sleep",           involveHandoff: true }
      ]
      scope.numberOfHandoffs(fake_activities).should.eql 2

    it "display the 0 if there is no handoff", ->
      fake_activities = [
        { date: "date", description: "play with kitty", involveHandoff: no },
        { date: "date", description: "feed ferrets",    involveHandoff: no },
        { date: "date", description: "sleep",           involveHandoff: no }
      ]
      scope.numberOfHandoffs(fake_activities).should.eql 0

  describe "selecting an activity", ->

    it "displays the selected activity", ->
      scope.select activities[1]

      scope.selectedActivity.should.eql activities[1]

  describe "adding a new activity", ->
    newActivity = defaultValues = now = undefined

    mockTheClockWith = (_now) ->
      Date.now = sinon.stub()
      Date.now.returns new Date(_now).getTime()
      _now

    beforeEach ->
      newActivity = "some new activity returned by the server"
      defaultValues = date: newActivity.date, description: newActivity.description
      activitiesService.createActivity.yields newActivity
      now = mockTheClockWith "01/01/2014 02:00 PM"

    describe "when no activities exist", ->
      beforeEach -> scope.activities = []

      it "defaults to the current date and time", ->
        scope.new()
 
        values = date: now, description: "New Activity"
        activitiesService.createActivity.should.have.been.calledWith userId, values

    it "uses the date of the most recently entered activity", ->
      scope.new()

      values = date: secondActivity.date, description: "New Activity"
      activitiesService.createActivity.should.have.been.calledWith userId, values

    it "displays the new activity", ->
      scope.new()

      scope.activities.should.contain newActivity

    it "selects the new activity", ->
      scope.new()

      scope.selectedActivity.should.eql newActivity

  describe "saving the selected activity", ->

    beforeEach ->
      scope.selectedActivity = 
        "_id": "$oid": activityId
        "date": values.date
        "description": values.description
        "involveHandoff": values.involveHandoff
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
