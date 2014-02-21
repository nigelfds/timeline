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


# timeline stuff (NOT TESTED YET)
angular.module('timeline')
  .directive('timeline', [ ->
      restrict: 'E',
      template: '<div></div>'
      link: (scope, element, attrs) ->

        onChanges = (newValue, oldValue) ->  updateTimeline()
        scope.$watch "activities", onChanges, true

        mapToTimeline = (activity) ->
          start: new Date(activity.date)
          content: activity.description

        updateTimeline = ->
          timelineData = scope.activities.map mapToTimeline
          timeline.setData timelineData
          timeline.setVisibleChartRangeAuto()
          timeline.zoom(-.2)

        timeline = new links.Timeline(element.children()[0])
        options =
          "width":  "100%"
          "height": "400px"
          "style": "box"

        timeline.draw [], options

        onSelect =  ->
          selection = timeline.getSelection()
          if selection.length > 0
            scope.select selection[0].row
            scope.$apply()

        links.events.addListener timeline, 'select', onSelect
  ]
)