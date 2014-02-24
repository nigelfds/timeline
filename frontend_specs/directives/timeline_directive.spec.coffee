describe "Timeline Directive", ->

  beforeEach module 'timeline'

  beforeEach inject ($rootScope, $compile) ->
    element = angular.element '<timeline></timeline>'
    scope = $rootScope.$new()
    element = $compile(element) scope

  xit "draws an empty timeline", ->

    options =
      "width":  "100%"
      "height": "400px"
      "style": "box"
      "zoomMax": 31536000000 # one year in milliseconds
      "zoomMin": 86400000 # one day in milliseconds


    timeline.draw.should.be.calledWith [], options

