describe 'UsersService', () ->

    service = $httpBackend = undefined

    beforeEach module "timeline"

    beforeEach inject (_UsersService_, _$httpBackend_) ->
        service = _UsersService_
        $httpBackend = _$httpBackend_

    it "should callback with the list of users", (done) ->
        users = []
        $httpBackend.when("GET", "/users").respond users

        service.getUsers (_users) ->
            _users.should.eql users
            done()

        $httpBackend.flush()

    it "should return a user", (done) ->
        test_user = id: "some_user_id"
        user = name: "Seaton"
        $httpBackend.when("GET", "/users/#{test_user.id}").respond user

        service.getUser test_user.id, (_user) ->
            _user.should.eql user
            done()

        $httpBackend.flush()

    describe 'when creating a new user' , ()->
        it 'should make a post to the user api', ()->
            postedEvent = angular.toJson {name: "Barry"}
            $httpBackend.whenPOST('/users', postedEvent).respond {}
            $httpBackend.expectPOST('/users', postedEvent).respond {name: "Barry", id: "12345"}

            service.createUser postedEvent, (new_user) ->
                new_user.should.eql {name: "Barry", id: "12345"}

            $httpBackend.flush()


