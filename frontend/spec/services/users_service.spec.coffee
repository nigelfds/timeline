describe 'UsersService', () ->

	UserService = undefined
	$httpBackend = undefined

	beforeEach module 'timeline'

	beforeEach inject (_UserService_, _$httpBackend_) ->
		UserService = _UserService_
		$httpBackend = _$httpBackend_


	it 'should make a get request to user_list_api', () ->
    	$httpBackend.whenGET('/user_list_api').respond []
    	$httpBackend.expectGET('/user_list_api')
    	UserService.getUsers(() ->)
    	$httpBackend.flush()

    it 'should execute the callback function', () ->
    	$httpBackend.whenGET('/user_list_api').respond []
    	callback = sinon.spy()

    	UserService.getUsers(callback)
    	$httpBackend.flush()

    	expect(callback.called).to.be.true



# describe 'UserService alternative', () ->

#     server = undefined

#     beforeEach -> server = sinon.fakeServer.create()

#     afterEach -> server = server.restore()

#     it "should return the list of users", ->

#         service = new UsersService
