describe 'UserService', () ->

    UserService = undefined
    $httpBackend = undefined

    beforeEach module 'timeline'

    beforeEach inject (_UserService_, _$httpBackend_) ->
        UserService = _UserService_
        $httpBackend = _$httpBackend_


    it 'should make a get request to user_list_api', () ->
        $httpBackend.whenGET('http://0.0.0.0:9292/patient').respond {"patients":[]}
        $httpBackend.expectGET('http://0.0.0.0:9292/patient')
        UserService.getUsers(() ->)
        $httpBackend.flush()

    it 'should execute the callback function', () ->
        $httpBackend.whenGET('http://0.0.0.0:9292/patient').respond {"patients":[]}
        callback = sinon.spy()

        UserService.getUsers(callback)
        $httpBackend.flush()

        expect(callback.called).to.be.true