describe "Timeline Directive", ->
  scope = timeline = listeners = watchHandlers = undefined

  firstActivity = date: "11/11/2011 02:55 PM", description: "Some description", isAPM: true
  secondActivity = date: "12/11/2011 03:55 PM", description: "Some other description", isAPM: false
  activities = [ firstActivity, secondActivity ]

  beforeEach module 'timeline'

  beforeEach inject ($rootScope, $compile) ->
    element = angular.element '<timeline></timeline>'
    scope = $rootScope.$new()

    timeline = sinon.createStubInstance links.Timeline
    sinon.stub(links, "Timeline").returns timeline

    listeners = {}
    sinon.stub links.events, "addListener", (_timeline, _eventName, _handler) ->
      listeners[_eventName] = _handler

    watchHandlers = {}
    sinon.stub scope, "$watch", (_propertyName, _handler, _deep) ->
      _deep.should.be.true
      watchHandlers[_propertyName] = _handler

    scope.activities = activities

    @execute = -> $compile(element) scope

  afterEach ->
    links.Timeline.restore()
    links.events.addListener.restore()

  it "draws an empty timeline", ->
    @execute()

    options =
      "width":  "100%"
      "height": "400px"
      "style": "box"
      "zoomMax": 31536000000 # one year in milliseconds
      "zoomMin": 86400000 # one day in milliseconds

    timeline.draw.should.be.calledWith [], options

  describe "select item on the timeline", ->

    beforeEach ->
      scope.select = sinon.stub()
      scope.$apply = sinon.stub()
      timeline.getSelection.returns [ row: 1 ]

    it "selects the activity on the scope", ->
      @execute()
      listeners["select"]()
      scope.select.should.have.been.calledWith secondActivity

    it "applys the changes to the scope", ->
      @execute()
      listeners["select"]()
      scope.$apply.should.have.been.called


    describe "nothing is selected", ->
      beforeEach ->
        timeline.getSelection.returns []

      it "deselect an activity from the scope", ->
        @execute()
        listeners["select"]()
        scope.select.should.have.been.calledWith undefined

  describe "the activities change", ->

    it "updates the timeline", ->

      @execute()
      watchHandlers["activities"]()

      timelineData = [
        { start: moment("11 Nov 2011 14:55").toDate(), content: "Some description", className: "apm", group: "APM" }
        { start: moment("12 Nov 2011 15:55").toDate(), content: "Some other description", className: "", group: "Outside APM" }
      ]
      timeline.setData.should.have.been.calledWith timelineData

    it "configures the timeline", ->
      @execute()
      watchHandlers["activities"]()

      timeline.setVisibleChartRangeAuto.should.have.been.called
      timeline.zoom.should.have.been.calledWith -0.2

  describe "selected activity changes", ->

    it "selects the activity on the timeline", ->
      @execute()
      watchHandlers["selectedActivity"](secondActivity)

      timeline.setSelection.should.have.been.calledWith [ row: 1 ]





