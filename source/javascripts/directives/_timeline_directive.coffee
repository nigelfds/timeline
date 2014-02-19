angular.module('timeline')
  .directive('eventtimeline', [
    () ->
      restrict: 'A',
      template: '<div id="user-timeline">'
      link: (scope, element, attrs) ->
        timeline = new links.Timeline(element.children()[0])
        options =
          "width":  "100%"
          "height": "400px"
          "style": "box"
          "groupsOnRight": "true"

        timeline.draw [], options


        drawTimeline= (events) ->
          timeline.setData(events)

          timeline.setVisibleChartRangeAuto()
          timeline.zoom(-.1)

        scope.$watchCollection('events',
          () ->
            drawTimeline(scope.events) if(scope.events)
        )
  ]
)