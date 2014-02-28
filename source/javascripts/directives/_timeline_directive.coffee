angular.module('timeline')
  .directive('timeline', [ ->
      restrict: 'E',
      template: '<div></div>'
      link: (scope, element, attrs) ->

        onChanges = -> updateTimeline()
        scope.$watch "activities", onChanges, true

        onSelectionChange = (activity) -> 
          index = scope.activities.indexOf(activity)
          timeline.setSelection [ row: index ]

        scope.$watch "selectedActivity", onSelectionChange, true

        mapToTimeline = (activity) ->
          start = moment(activity.date, "DD/MM/YYYY hh:mm A").toDate()

          content = """
            <div class="timeline-activity panel panel-info" ondblclick="getScope().edit()">
              <div class="panel-heading">
                <span class="glyphicon glyphicon-calendar"></span>
                #{activity.date}
              </div>
              <div class="panel-body">
                  #{activity.description}
              </div>
            </div>
          """

          start: start
          content: content
          className: if activity.isAPM then "apm" else ""
          group: if activity.isAPM then "APM" else "Outside APM"

        updateTimeline = ->
          timelineData = scope.activities.map mapToTimeline
          timeline.setData timelineData
          updateTimelineOptions()

        timeline = new links.Timeline(element.children()[0])
        options =
          width:  "100%"
          minHeight: 600
          style: "box"
          zoomMin: 86400000 # one day in milliseconds
          customStackOrder: (item1, item2) -> item1.start - item2.start
          animateZoom: false
          groupsOrder: (group1, group2) -> 
            if group1.content < group2.content
            then return 1 
            else if group1.content > group2.content
            then return -1
            else return 0

          # showCurrentTime: false
          # box: align: "left"
          # animate: true
          # editable: true
          # cluster: true

        timeline.draw [], options

        # onEdit = ->
        #   selection = timeline.getSelection()
        #   selectActivity = scope.activities[selection[0].row] if selection.length > 0
        #   scope.select selectActivity
        #   scope.$apply()
        #   $('#activityEditor').modal('show');

        # links.events.addListener timeline, 'edit', onEdit

        onSelect = ->
          selection = timeline.getSelection()
          selectActivity = scope.activities[selection[0].row] if selection.length > 0
          scope.select selectActivity
          scope.$apply()

        links.events.addListener timeline, 'select', onSelect

        # TOTALLY UNTESTED CODE *****************************
        links.events.addListener timeline, 'rangechanged', ->
          updateTimelineOptions()

        updateTimelineOptions = ->
          moments = []
          for activity in scope.activities
            moments.push moment(activity.date, "DD/MM/YYYY hh:mm A")
          moments.sort (x, y) -> x.toDate() - y.toDate()

          if moments.length is 0 then return

          maxMoment = moment(moments[moments.length - 1])
          minMoment = moment(moments[0])

          visibleRange = timeline.getVisibleChartRange()

          range = visibleRange.end.getTime() - visibleRange.start.getTime()
          range = 0.1 * range
          range = Math.max(range, 86400000)

          maxMoment.add("ms", range)
          minMoment.subtract("ms", range)

          max = maxMoment.toDate()
          min = minMoment.toDate()

          timeline.options.max = max
          timeline.options.min = min
          timeline.options.zoomMax = max - min
  ]
)