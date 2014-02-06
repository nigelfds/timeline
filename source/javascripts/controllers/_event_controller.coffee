EventController = ($scope, $routeParams, EventService) ->

    $scope.date = new Date()
    $scope.time = new Date()
    $scope.time.setHours(12)
    $scope.time.setMinutes(0)

    EventService.getEvents($routeParams.userId, (events) ->

    	$scope.events = events.events.map((the_event) ->
    		return {
    			content: the_event.description
    			start: new Date(the_event.start)
    		}
    	)
    )

    $scope.createEvent = () ->

        dateTime = new Date(
            $scope.date.getFullYear(),
            $scope.date.getMonth(),
            $scope.date.getDate(),
            $scope.time.getHours(),
            $scope.time.getMinutes()
        )
        EventService.createEvent
            description: $scope.description
            start: dateTime.toString(), $routeParams.userId, (new_event) ->
            $scope.events.push(new_event)

        $scope.events.push({content: $scope.description, start: dateTime})

angular.module('timeline')
    .controller 'EventController', EventController