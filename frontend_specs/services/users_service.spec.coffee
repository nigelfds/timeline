describe 'UsersService', () ->

    service = $httpBackend = undefined

    beforeEach module "timeline"

    beforeEach inject (_UsersService_, _$httpBackend_) ->
        service = _UsersService_
        $httpBackend = _$httpBackend_

    it "should callback with the list of users", (done) ->
        users = {"patients":[]}
        $httpBackend.when("GET", "/patient").respond users

        service.getUsers (_users) ->
            _users.should.eql users
            done()

        $httpBackend.flush()

    describe 'when creating a new user' , ()->
        it 'should make a post to the user api', ()->
            postedEvent = angular.toJson {name: "Barry"}
            $httpBackend.whenPOST('/patient', postedEvent).respond {}
            $httpBackend.expectPOST('/patient', postedEvent).respond {name: "Barry", id: "12345"}

            service.createUser postedEvent, (new_user) ->
                new_user.should.eql {name: "Barry", id: "12345"}


            $httpBackend.flush()


