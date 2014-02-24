# timeline stuff (NOT TESTED YET)
angular.module('timeline')
  .directive('timeline', [ ->
      restrict: 'E',
      template: '<div></div>'
      link: (scope, element, attrs) ->

        onChanges = (newValue, oldValue) ->  updateTimeline()
        scope.$watch "activities", onChanges, true

        onSelectionChange = (newValue, oldValue) -> 
          index = scope.activities.indexOf(newValue)
          timeline.setSelection [ row: index ]

        scope.$watch "selectedActivity", onSelectionChange, true

        mapToTimeline = (activity) ->
          start = moment(activity.date, "DD/mm/YYYY hh:mm P").toDate()
          group = if activity.isAPM then "Part of APM" else "Not APM"
          start: start
          content: activity.description
          group: group
          className: if activity.isAPM then "apm" else ""

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
          # "zoomable": false
          "zoomMax": 31536000000 # one year in milliseconds
          "zoomMin": 86400000 # one day in milliseconds

        timeline.draw [], options

        onSelect =  ->
          selection = timeline.getSelection()
          selectActivity = scope.activities[selection[0].row] if selection.length > 0
          scope.select selectActivity
          scope.$apply()

        links.events.addListener timeline, 'select', onSelect
  ]
)