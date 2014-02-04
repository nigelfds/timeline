angular.module('timeline')
	.directive('eventtimeline', [
		() ->
			restrict: 'E',
			template: '<div id="user-timeline">'
			link: (scope, element, attrs) ->
				timeline = new links.Timeline(element.children()[0])

				drawTimeline= (events) ->
					data = events
					options =
						"width":  "100%"
						"height": "400px"
						"style": "box"
						"groupsOnRight": "true"

					timeline.draw data, options

					timeline.setVisibleChartRangeAuto()

				scope.$watch('events',
					() ->
						drawTimeline(scope.events) if(scope.events)
				)
	]
)