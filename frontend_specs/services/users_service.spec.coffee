describe 'UsersService', () ->

  service = $httpBackend = undefined

  beforeEach module "timeline"

  beforeEach inject (_UsersService_, _$httpBackend_) ->
    service = _UsersService_
    $httpBackend = _$httpBackend_

  describe "getUsers", ->

    it "should callback with the list of users", ->
      users = []
      $httpBackend.when("GET", "/users").respond users

      result = undefined
      service.getUsers (_users) -> result = _users
      $httpBackend.flush()

      result.should.eql users

  describe "getUser", ->

    it "should return a user", ->
      test_user = id: "some_user_id"
      user = name: "Seaton"
      $httpBackend.when("GET", "/users/#{test_user.id}").respond user

      result = undefined
      service.getUser test_user.id, (_user) -> result = _user
      $httpBackend.flush()

      result.should.eql user


  describe "createUser" , ->
    user = undefined

    beforeEach -> 
      user = name: "Barry"

    it 'returns the created user', ->
      createdUser = _id: {$oid: "12345"}, name: "Barry"
      $httpBackend.when("POST", "/users", user).respond createdUser

      result = undefined
      service.createUser user, (_result) -> result = _result
      $httpBackend.flush()

      result.success.should.be.true
      result.user.should.eql createdUser

    describe "an error occurs", ->

      it "returns a message about the error", ->
        errorMessage = "Unable to create user"
        $httpBackend.when("POST", "/users", user).respond 500, errorMessage

        result = undefined
        service.createUser user, (_result) -> result = _result
        $httpBackend.flush()

        result.success.should.be.false
        result.message.should.eql errorMessage

  describe "updateUser", ->
    user = id: "some_id"
    updatedUser = undefined
    beforeEach ->
      updatedUser = "numberOfHandovers": 34

    it "returns a successful result", ->
      $httpBackend.when("PUT", "/users/#{user.id}", updatedUser).respond {}

      result = undefined
      service.updateUser user.id, updatedUser, (_result) -> result = _result
      $httpBackend.flush()

      result.success.should.eql true
    
    describe "an error occurs", ->

      it "returns a message about the error", ->
        errorMessage = "Unable to update user"
        $httpBackend.when("PUT", "/users/#{user.id}", updatedUser).respond 500, errorMessage

        result = undefined
        service.updateUser user.id, updatedUser, (_result) -> result = _result
        $httpBackend.flush()

        result.success.should.be.false
        result.message.should.eql errorMessage



