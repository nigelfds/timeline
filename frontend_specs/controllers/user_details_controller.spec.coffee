describe "UserDetailsController", ->
  userId = "the-user-id"
  user =
    "_id": "$oid": userId
    name: "Barry"
    urNumber: "1234567890"
    age:"35"
    gender:"male"

  scope = timeout = service = undefined

  beforeEach module("timeline")
  beforeEach inject (_$rootScope_, _$timeout_) ->
    scope = _$rootScope_.$new()
    timeout = _$timeout_
  beforeEach ->
    service = sinon.createStubInstance UsersService

    messages = sinon.createStubInstance MessagesList
    sinon.stub(window, "MessagesList").returns messages

  afterEach ->
    MessagesList.restore()    


  describe "saving the user", ->

    values = name: user.name, urNumber: user.urNumber, age: user.age, gender: user.gender

    describe "the update succeeds", ->

      beforeEach -> service.updateUser.withArgs(userId, values).yields true

      it "displays an update success message", ->
        UserDetailsController scope, timeout, service

        scope.save(user)

        scope.messages.add.should.have.been.calledWith "Updated successfully", "success"

    describe "the update fails", ->

      beforeEach -> service.updateUser.withArgs(userId, values).yields false

      it "displays a failure message", ->
        UserDetailsController scope, timeout, service

        scope.save(user)

        scope.messages.add.should.have.been.calledWith "Update failed", "danger"

