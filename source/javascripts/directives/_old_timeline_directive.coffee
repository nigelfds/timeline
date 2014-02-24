angular.module('timeline')
  .directive('eventtimeline', [
    () ->
      restrict: 'A',
      template: '<div id="user-timeline">'
      link: (scope, element, attrs) ->
        timeline = new links.Timeline(element.children()[0])

        onSelect = (e) ->
          activity = scope.activities[timeline.getSelection()[0].row]
          scope.selectActivity activity


        links.events.addListener(timeline, 'select', onSelect);

        options =
          "width":  "100%"
          "height": "400px"
          "style": "box"
          "groupsOnRight": "true"

        timeline.draw [], options

        drawTimeline = (data) ->
          timeline.setData(data)
          timeline.setVisibleChartRangeAuto()
          timeline.zoom(-.1)

        scope.$watchCollection 'timelineData', ->
          drawTimeline(scope.timelineData) if(scope.timelineData)
  ]
)