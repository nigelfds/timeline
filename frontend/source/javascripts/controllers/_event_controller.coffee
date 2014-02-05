EventController = ($scope, $routeParams, EventService) ->
    EventService.getEvents($routeParams.userId, (events) ->

    	$scope.events = events.events.map((the_event) ->
    		return {
    			content: the_event.description
    			start: new Date(the_event.start)
    		}
    	)
    )

angular.module('timeline')
    .controller 'EventController', EventController