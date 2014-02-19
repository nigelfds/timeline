describe "EventController", ->

    userId = '52f0329df6f4070ce200000'
    _scope = routeParams = undefined

    beforeEach ->
        _scope = {}
        routeParams = {
                userId: userId
            }


    describe 'when there are no events', ->

        beforeEach ->
            eventService = sinon.createStubInstance EventsService
            eventService.getEvents.withArgs(userId).yields []

            eventController = EventController _scope, routeParams, eventService

        it "should display an empty list", ->
            _scope.events.length.should.eql 0


    describe 'when there are 2 events', ->
        date = new Date(Date.now())

        beforeEach ->
            event1 = {description: "Some Event", userId: userId, start: date.toUTCString()}
            event2 = {description: "Another Event", userId: userId, start: date.toUTCString()}
            eventService = sinon.createStubInstance EventsService
            eventService.getEvents.yields [event1, event2]

            eventController = EventController _scope, routeParams, eventService

        it "should display events", ->
            _scope.events[0].content.should.eql "Some Event"
            expect(_scope.events[0].start).to.equalDate date

            _scope.events[1].content.should.eql "Another Event"
            expect(_scope.events[1].start).to.equalDate date

    describe 'when adding a new event' , ->
        event1=undefined
        date = new Date(2013,2,12,0,0,0)
        time = new Date(2013,0,0,10,15,0)
        eventService = undefined

        beforeEach ->
            event1 = {description: "Some Event", start: date.toUTCString()}
            eventService = sinon.createStubInstance EventsService
            eventService.getEvents.withArgs(userId).yields []
            eventService.createEvent.yields {description: "Some Event"}

        it 'should create a new event with valid data', ->
            eventController = EventController _scope, routeParams, eventService

            _scope.date = date
            _scope.time = date
            _scope.description = "Some Event"

            _scope.createEvent()

            eventService.createEvent.should.have.been.calledWith {description: "Some Event", start: date.toString()}

        it 'should produce a request with combined date and time', ->
            eventController = EventController _scope, routeParams, eventService

            _scope.date = date
            _scope.time = time
            _scope.description = "Some Event"

            _scope.createEvent()

            eventService.createEvent.should.have.been.calledWith {
                description: "Some Event",
                start: new Date(2013,2,12,10,15,0).toString()
            }

        it 'should append new event to the scope', ->
            eventController = EventController _scope, routeParams, eventService

            _scope.date = date
            _scope.time = time
            _scope.description = "Some Event"

            _scope.createEvent()

            _scope.events.length.should.be.eql 1

        it 'should initialise the time and date variables', ->
            eventController = EventController _scope, routeParams, eventService

            expect(_scope.date).to.exist
            expect(_scope.time).to.exist

