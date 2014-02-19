describe 'EventService', () ->

    EventService = undefined
    $httpBackend = undefined
    userId = '52f0329df6f4070ce200000'

    beforeEach module 'timeline'

    beforeEach inject (_EventService_, _$httpBackend_) ->
        EventService = _EventService_
        $httpBackend = _$httpBackend_

    describe 'when retrieving a list of activities', ->
        it 'returns the correct activities', ->
            $httpBackend.whenGET("/users/#{userId}/activities").respond ["activity1", "activity2"]

            EventService.getEvents userId, (activities) ->
                activities.should.eql ["activity1", "activity2"]

            $httpBackend.flush()

    describe 'when creating a new event' , ->
        it 'should make a post to the event api', ()->
            values = angular.toJson {description: "Some content", start: Date.now()}

            $httpBackend.whenPOST("/users/#{userId}/activities", values).respond {description: "Some content"}

            EventService.createEvent values, userId, (activity) ->
                activity.should.eql {description: "Some content"}

            $httpBackend.flush()