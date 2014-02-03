describe 'UsersService', () ->

	UsersService = undefined
	$httpBackend = undefined

	beforeEach module 'timeline'

	beforeEach inject (_UsersService_, _$httpBackend_) ->
		UsersService = _UsersService_
		$httpBackend = _$httpBackend_


	it 'should make a get request to user_list_api', () ->
    	$httpBackend.whenGET('http://0.0.0.0:9292/patient').respond {"patients":[]}
    	$httpBackend.expectGET('http://0.0.0.0:9292/patient')
    	UsersService.getUsers(() ->)
    	$httpBackend.flush()

    it 'should execute the callback function', () ->
    	$httpBackend.whenGET('http://0.0.0.0:9292/patient').respond {"patients":[]}
    	callback = sinon.spy()

    	UsersService.getUsers(callback)
    	$httpBackend.flush()

    	expect(callback.called).to.be.true



# describe 'UsersService alternative', () ->

#     service = httpBackend = undefined

#     beforeEach -> module "timeline"

#     beforeEach -> inject (_UsersService_, _$httpBackend_) ->
#         service = _UsersService_
#         httpBackend = _$httpBackend_

#     it "should return the list of users", (done) ->
#         httpBackend.when("GET", "/user_list_api").respond "users"

#         service.getUsers (users) ->
#             users.should.eql "users"
#             done()

