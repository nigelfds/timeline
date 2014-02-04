describe "EventController", ->

    userId = '52f0329df6f4070ce200000'
    _scope = routeParams = undefined

    beforeEach ->
        _scope = {}
        routeParams = {
                userId: userId
            }


    describe 'when there are no events', ->
        _scope = undefined

        beforeEach ->
            eventService = sinon.createStubInstance EventsService
            eventService.getEvents.yields {"events":[]}

            eventController = EventController _scope, routeParams, eventService

        it "should display an empty list", ->
            _scope.events.length.should.eql 0


    describe 'when there are 2 events', ->
        _scope = undefined
        date = new Date(Date.now())

        beforeEach ->
            event1 = {description: "Some Event", userId: userId, start: date.toUTCString()}
            event2 = {description: "Another Event", userId: userId, start: date.toUTCString()}
            eventService = sinon.createStubInstance EventsService
            eventService.getEvents.yields {"events":[event1, event2]}

            eventController = EventController _scope, routeParams, eventService

        it "should display events", ->
            _scope.events[0].content.should.eql "Some Event"
            _scope.events[0].start.should.equalDate date

            _scope.events[1].content.should.eql "Another Event"
            _scope.events[1].start.should.equalDate date