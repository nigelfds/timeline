angular.module('timeline')
  .directive('timeline', [ ->
      restrict: 'E',
      template: '<div></div>'
      link: (scope, element, attrs) ->

        onChanges = ->  updateTimeline()
        scope.$watch "activities", onChanges, true

        onSelectionChange = (activity) -> 
          index = scope.activities.indexOf(activity)
          timeline.setSelection [ row: index ]

        scope.$watch "selectedActivity", onSelectionChange, true

        mapToTimeline = (activity) ->
          start = moment(activity.date, "DD/MM/YYYY hh:mm A").toDate()

          start: start
          content: activity.description
          className: if activity.isAPM then "apm" else ""
          group: if activity.isAPM then "APM" else "Outside APM"

        updateTimeline = ->
          timelineData = scope.activities.map mapToTimeline
          timeline.setData timelineData
          timeline.setVisibleChartRangeAuto()
          timeline.zoom -0.2

        timeline = new links.Timeline(element.children()[0])
        options =
          width:  "100%"
          minHeight: "400px"
          style: "box"
          zoomMax: 31536000000 # one year in milliseconds
          zoomMin: 86400000 # one day in milliseconds
          customStackOrder: (item1, item2) -> item1.start - item2.start



        timeline.draw [], options

        onSelect =  ->
          selection = timeline.getSelection()
          selectActivity = scope.activities[selection[0].row] if selection.length > 0
          scope.select selectActivity
          scope.$apply()

        links.events.addListener timeline, 'select', onSelect
  ]
)