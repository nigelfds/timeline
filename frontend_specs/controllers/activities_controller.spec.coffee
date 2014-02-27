describe "ActivitiesController", ->
  scope = routeParams = timeout = activitiesService = usersService = alerts = undefined
  userId = "the-user-id"
  activityId = values = currentUser = undefined

  firstActivity = date: "11/11/2011 02:55 PM", description: "Some description", isAPM: true
  secondActivity = date: "12/11/2011 03:55 PM", description: "Some other description", isAPM: false
  activities = [ firstActivity, secondActivity ]

  beforeEach module("timeline")

  beforeEach inject (_$rootScope_) ->
    scope = _$rootScope_.$new()
    routeParams = userId: userId
    sinon.stub(angular, "element", (selector) -> modal: sinon.stub())

  afterEach -> angular.element.restore()

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

    alerts = sinon.createStubInstance MessagesList
    sinon.stub(window, "MessagesList").returns alerts

    ActivitiesController scope, routeParams, timeout, activitiesService, usersService

  afterEach -> MessagesList.restore()

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
      alerts.add.should.have.been.calledWith "Updated successfully", "success"


  describe "removing an activity", ->
    selectedActivity = undefined
    beforeEach ->
      confirm = sinon.stub()
      selectedActivity =
        "_id": "$oid": activityId
        "date": values.date
        "description": values.description
        "user_id": "$oid": userId
      scope.selectedActivity = selectedActivity
      scope.activities.push selectedActivity
      activitiesService.deleteActivity.withArgs(userId, activityId).yields true

    it "removes the activity", ->
      scope.delete()
      scope.activities.should.not.contain selectedActivity

    xit "unselects the activity", ->
      scope.delete()
      expect(scope.selectedActivity).to.eql undefined

  describe "addNewStaffInvolved", ->
    beforeEach ->
      scope.selectedActivity =
        "_id": "$oid": activityId
        "date": values.date
        "description": values.description
        "involveHandoff": values.involveHandoff
        "user_id": "$oid": userId

    it "sends an update to the service", ->
      values.staffInvolved = [ "Justin" ]
      scope.newStaffName = "Justin"

      scope.addNewStaffInvolved()
      activitiesService.updateActivity.should.have.been.calledWith(userId, activityId, values)

    it "should have newly entered name with all the existing staff involved", ->
      scope.selectedActivity.staffInvolved = [ "kitty" ]
      scope.newStaffName = "panda"

      scope.addNewStaffInvolved()
      scope.selectedActivity.staffInvolved.should.eql [ "kitty", "panda"]

    it "should empty the textbox after name is entered", ->
      scope.newStaffName = "panda"
      scope.addNewStaffInvolved()
      scope.newStaffName.should.be.empty

    it "should not allow adding the same staff name twice", ->
      scope.selectedActivity.staffInvolved = [ "kitty" ]
      scope.newStaffName = "kitty"

      scope.addNewStaffInvolved()
      scope.selectedActivity.staffInvolved.should.eql [ "kitty" ]

  describe "removeStaffInvolved", ->
    beforeEach ->
      scope.selectedActivity =
        "_id": "$oid": activityId
        "date": values.date
        "description": values.description
        "involveHandoff": values.involveHandoff
        "user_id": "$oid": userId

    it "should remove the staff from that activity", ->
      scope.selectedActivity.staffInvolved = [ "kitty", "panda", "teddy" ]

      scope.removeStaffInvolved("panda")
      scope.selectedActivity.staffInvolved.should.eql [ "kitty", "teddy"]

    it "sends an update to the service", ->
      scope.selectedActivity.staffInvolved = [ "kitty", "panda", "teddy" ]

      scope.removeStaffInvolved("panda")

      values.staffInvolved = [ "kitty", "teddy" ]
      activitiesService.updateActivity.should.have.been.calledWith(userId, activityId, values)

  describe "unique IT systems", ->

    fakeActivities1 = [
      { date: "date", description: "play with kitty", itSystems:  ["a", "b", "c"]},
      { date: "date", description: "feed ferrets",    itSystems:  ["c"]},
      { date: "date", description: "sleep",           itSystems:  ["b", "e"]}
    ]

    fakeActivities2 = [
      { date: "date", description: "play with kitty"},
      { date: "date", description: "feed ferrets"   },
      { date: "date", description: "sleep"          }
    ]

    it "sort out the unique IT System updated across all activities", ->
      scope.itSystemsUpdated(fakeActivities1).should.eql ["a", "b", "c", "e"]

    it "return empty list if no IT systems get updated", ->
      scope.itSystemsUpdated(fakeActivities2).should.eql []

  describe "IT Systems", ->

    beforeEach ->
      scope.selectedActivity =
        "_id": "$oid": activityId
        "date": values.date
        "description": values.description
        "involveHandoff": values.involveHandoff
        "user_id": "$oid": userId

    describe "addNewITSystem", ->
      it "sends an update to the service", ->
        values.itSystems = [ "Justin" ]
        scope.newITSystemName = "Justin"

        scope.addNewITSystem()
        activitiesService.updateActivity.should.have.been.calledWith(userId, activityId, values)

      it "should have newly entered IT System name with all the existing IT Systems", ->
        scope.selectedActivity.itSystems = [ "system 1" ]
        scope.newITSystemName = "system 2"

        scope.addNewITSystem()
        scope.selectedActivity.itSystems.should.eql [ "system 1", "system 2"]

      it "should not allow adding the same IT system name twice", ->
        scope.selectedActivity.itSystems = [ "system A" ]
        scope.newITSystemName = "system A"

        scope.addNewITSystem()
        scope.selectedActivity.itSystems.should.eql [ "system A" ]

      it "should empty the textbox after system name is entered", ->
        scope.newITSystemName = "new system"
        scope.addNewITSystem()
        scope.newITSystemName.should.be.empty

    describe "removeITSystem", ->
      beforeEach ->
        scope.selectedActivity.itSystems = [ "system A", "system B", "system C" ]

      it "should remove the IT system name from that activity", ->
        scope.removeITSystem("system B")
        scope.selectedActivity.itSystems.should.eql [ "system A", "system C" ]

      it "sends an update to the service", ->
        scope.removeITSystem("system B")

        values.itSystems = [ "system A", "system C" ]
        activitiesService.updateActivity.should.have.been.calledWith(userId, activityId, values)

  describe "Paper Records", ->

    beforeEach ->
      scope.selectedActivity =
        "_id": "$oid": activityId
        "date": values.date
        "description": values.description
        "involveHandoff": values.involveHandoff
        "user_id": "$oid": userId

    describe "addNewPaperRecord", ->
      it "sends an update to the service", ->
        values.paperRecords = [ "Form A" ]
        scope.newPaperRecord = "Form A"

        scope.addNewPaperRecord()
        activitiesService.updateActivity.should.have.been.calledWith(userId, activityId, values)

      it "should have newly entered IT System name with all the existing IT Systems", ->
        scope.selectedActivity.paperRecords = [ "Form A" ]
        scope.newPaperRecord = "Form B"

        scope.addNewPaperRecord()
        scope.selectedActivity.paperRecords.should.eql [ "Form A", "Form B"]

      it "should not allow adding the same IT system name twice", ->
        scope.selectedActivity.paperRecords = [ "Form A" ]
        scope.newPaperRecord = "Form A"

        scope.addNewPaperRecord()
        scope.selectedActivity.paperRecords.should.eql [ "Form A" ]

      it "should empty the textbox after system name is entered", ->
        scope.newPaperRecord = "new Form"
        scope.addNewPaperRecord()
        scope.newPaperRecord.should.be.empty

    describe "removePaperRecord", ->
      beforeEach ->
        scope.selectedActivity.paperRecords = [ "Form A", "Form B", "Form C" ]

      it "should remove the paper record name from that activity", ->
        scope.removePaperRecord("Form B")
        scope.selectedActivity.paperRecords.should.eql [ "Form A", "Form C" ]

      it "sends an update to the service", ->
        scope.removePaperRecord("Form B")

        values.paperRecords = [ "Form A", "Form C" ]
        activitiesService.updateActivity.should.have.been.calledWith(userId, activityId, values)

    describe "unique Paper Record name", ->
      fakeActivities1 = [
        { date: "date", description: "play with kitty", paperRecords:  ["a", "b", "c"]},
        { date: "date", description: "feed ferrets",    paperRecords:  ["b"]},
        { date: "date", description: "sleep",           paperRecords:  ["a", "e"]}
      ]

      fakeActivities2 = [
        { date: "date", description: "play with kitty"},
        { date: "date", description: "feed ferrets"   },
        { date: "date", description: "sleep"          }
      ]

      it "sort out the unique IT System updated across all activities", ->
        scope.paperRecordslist(fakeActivities1).should.eql ["a", "b", "c", "e"]

      it "return empty list if no IT systems get updated", ->
        scope.paperRecordslist(fakeActivities2).should.eql []

