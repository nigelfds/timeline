describe 'EventService', () ->

    EventService = undefined
    $httpBackend = undefined
    userId = '52f0329df6f4070ce200000'

    beforeEach module 'timeline'

    beforeEach inject (_EventService_, _$httpBackend_) ->
        EventService = _EventService_
        $httpBackend = _$httpBackend_


    it 'should make a get request to event api', () ->
        $httpBackend.whenGET('http://0.0.0.0:9292/patient/'+userId+'/event').respond {"events":[]}
        $httpBackend.expectGET('http://0.0.0.0:9292/patient/'+userId+'/event')
        EventService.getEvents(userId, () ->)
        $httpBackend.flush()

    it 'should execute the callback function', () ->
        $httpBackend.whenGET('http://0.0.0.0:9292/patient/'+userId+'/event').respond {"events":[]}
        callback = sinon.spy()

        EventService.getEvents(userId, callback)
        $httpBackend.flush()

        expect(callback.called).to.be.true