describe "EventController", ->

    userId = '52f0329df6f4070ce200000'

    xit "should display an empty list", ->
        eventService = sinon.createStubInstance EventsService
        eventService.getEvents.yields ([userId] [])
        _scope = {}

        routeParams = {
            userId: userId
        }

        eventController = EventController _scope, eventService, routeParams

        _scope.events.length.should.eql 0


    xit "should display users", ->
        barry = name: "Barry"
        michael = name: "Michael"
        eventService = sinon.createStubInstance EventsService
        eventService.getEvents.yields {"patients":[barry, michael]}
        _scope = {}

        eventController = EventController _scope, eventService

        _scope.events.should.contain barry
        _scope.events.should.contain michael