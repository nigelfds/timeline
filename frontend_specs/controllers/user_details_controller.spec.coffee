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

  describe "saving the user", ->

    values = name: user.name, urNumber: user.urNumber, age: user.age, gender: user.gender

    describe "the update succeeds", ->

      beforeEach -> service.updateUser.withArgs(userId, values).yields true

      it "displays an update success message", ->
        UserDetailsController scope, timeout, service

        scope.save(user)

        scope.messages[0].should.eql text: "Updated successfully", type: "success"


      it "removes alerts after a timeout", ->
        UserDetailsController scope, timeout, service

        scope.save(user)

        timeout.flush(10000)
        scope.messages.should.be.empty


    describe "the update fails", ->

      beforeEach -> service.updateUser.withArgs(userId, values).yields false

      it "displays a failure message", ->
        UserDetailsController scope, timeout, service

        scope.save(user)

        scope.messages[0].should.eql text: "Update failed", type: "danger"



