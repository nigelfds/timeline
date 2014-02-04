describe 'UsersService', () ->

    service = $httpBackend = undefined

    beforeEach module "timeline"

    beforeEach inject (_UsersService_, _$httpBackend_) ->
        service = _UsersService_
        $httpBackend = _$httpBackend_

    it "should callback with the list of users", (done) ->
        users = {"patients":[]}
        $httpBackend.when("GET", "http://0.0.0.0:9292/patient").respond users

        service.getUsers (_users) ->
            _users.should.eql users
            done()

        $httpBackend.flush()


