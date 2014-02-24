describe("Timeline Directive", ->

  scope = element = undefined
  userId = '52f0329df6f4070ce200000'


  beforeEach module 'timeline'

  beforeEach inject ($rootScope, $compile) ->
    element = angular.element '<div eventtimeline>'
    scope = $rootScope.$new()

    sinon.spy(scope, "$watch");

    element = $compile(element) scope
    scope.$apply()

  describe('when events are avaliable in scope', ->

        it 'should contain 2 events', ->
            event1 = {content: "Some event", start: new Date(Date.now())}
            event2 = {content: "Another event", start: new Date(Date.now())}
            scope.timelineData = [event1, event2]
            scope.$apply()

            eventElements = element.find('.timeline-event-content')
            eventElements.length.should.eql 2

        it 'should contain 3 elements', ->
            event1 = {content: "Some event", start: new Date(Date.now())}
            event2 = {content: "Another event", start: new Date(Date.now())}
            event3 = {content: "A third event", start: new Date(Date.now())}
            scope.timelineData = [event1, event2, event3]
            scope.$apply()

            eventElements = element.find('.timeline-event-content')
            eventElements.length.should.eql 3
  )
)
