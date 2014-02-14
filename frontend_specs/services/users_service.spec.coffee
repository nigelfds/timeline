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
            potential_user = {name: "Barry"}
            created_user = {name: "Barry", id: "12345"}
            $httpBackend.expectPOST('/users', potential_user).respond created_user

            service.createUser potential_user, (new_user) -> new_user.should.eql created_user

            $httpBackend.flush()

    describe "updating a user", ->

        it "sends the updated information to the server", ->
            test_user = id: "some_id"
            updatedUserData = "numberOfHandovers": 34
            $httpBackend.expectPUT("/users/some_id", updatedUserData).respond {}

            service.updateUser test_user.id, updatedUserData, (success) ->
                success.should.eql true


            $httpBackend.flush()




