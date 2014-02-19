describe 'EventService', () ->

  EventService = undefined
  $httpBackend = undefined
  userId = '52f0329df6f4070ce200000'

  beforeEach module 'timeline'

  beforeEach inject (_EventService_, _$httpBackend_) ->
    EventService = _EventService_
    $httpBackend = _$httpBackend_

  describe 'when retrieving a list of events', () ->
    it 'should make a get request to event api', () ->
      $httpBackend.whenGET('/users/'+userId+'/activities').respond {"activities":[]}
      $httpBackend.expectGET('/users/'+userId+'/activities')
      EventService.getEvents(userId, () ->)
      $httpBackend.flush()

    it 'should execute the callback function', () ->
      $httpBackend.whenGET('/users/'+userId+'/activities').respond {"activities":[]}
      callback = sinon.spy()

      EventService.getEvents(userId, callback)
      $httpBackend.flush()

      expect(callback.called).to.be.true

  describe 'when creating a new event' , ()->
    it 'should make a post to the event api', ()->

      postedEvent = angular.toJson {description: "Some content", start: new Date(Date.now())}
      $httpBackend.whenPOST('/users/'+userId+'/activities', postedEvent).respond {description: "Some content"}
      $httpBackend.expectPOST('/users/'+userId+'/activities', postedEvent)

      EventService.createEvent(postedEvent, userId, (new_event) ->
        new_event.should.eql {description: "Some content"}
      )

      $httpBackend.flush()
