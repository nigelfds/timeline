describe "User controller", ->

  scope = routeParams = usersService = activityService = timeout = location = undefined

  test_user =
    "_id": "some_user_id"
    "name": "Seaton"
    "urNumber": 123456789
    "age": 30
    "gender": "male"
    "numberOfHandovers": 45
    "numberOfPeopleInvolved": 10
    "numberOfContacts": 34

  beforeEach ->
    scope = {}
    routeParams = userId: test_user._id
    usersService = sinon.createStubInstance UsersService
    usersService.getUser.withArgs(test_user._id).yields test_user

    activityService = sinon.createStubInstance ActivityService

    timeout = sinon.stub()

    location = path: sinon.stub()

    UserController scope, routeParams, usersService, timeout, location, activityService

  it "displays the user", ->
    scope.user.should.be.eql test_user

  describe "save", ->
    beforeEach ->
      scope.user = test_user
      scope.userForm =
      numberOfHandovers: $valid : true
      numberOfPeopleInvolved: $valid : true
      numberOfContacts: $valid : true

    it "saves only the specified property", ->
      scope.save scope.userForm, "numberOfPeopleInvolved"

      data = "numberOfPeopleInvolved": test_user.numberOfPeopleInvolved

      usersService.updateUser.should.have.been.calledWith test_user._id, data

    it "alerts on success", ->
      data = "numberOfPeopleInvolved": test_user.numberOfPeopleInvolved
      usersService.updateUser.withArgs(test_user._id, data).yields true

      scope.save scope.userForm, "numberOfPeopleInvolved"

      scope.alerts[0].message.should.eql "Updated user successfully"

    it "removes alerts", ->
      data = "numberOfPeopleInvolved": test_user.numberOfPeopleInvolved
      usersService.updateUser.withArgs(test_user._id, data).yields true

      timeout.withArgs(sinon.match.func, 5000).yields()

      scope.save scope.userForm, "numberOfPeopleInvolved"

      scope.alerts.should.be.empty

    describe "when data is invalid", ->
      beforeEach -> scope.userForm.numberOfHandovers.$valid = false

      it "doesn't save the property", ->
        scope.save scope.userForm, "numberOfHandovers"

        usersService.updateUser.should.not.have.been.called

  describe "when creating a new activity", ->
    event = undefined

    beforeEach -> event = preventDefault: sinon.stub()


    it "prevents the default behaviour", ->
      scope.createActivity event, "activity-type"

      event.preventDefault.should.have.been.called

    it "displays the newly created activity", ->
      test_activity = _id: $oid: "activity-identifier"
      data =
        userId: routeParams.userId
        activityType: "activity-type"

      activityService.createActivity.withArgs(data).yields test_activity

      scope.createActivity event, data.activityType

      location.path.should.have.been.calledWith "/activities/#{test_activity._id.$oid}"

