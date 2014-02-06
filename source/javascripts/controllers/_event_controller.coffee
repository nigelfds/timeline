EventController = ($scope, $routeParams, EventService) ->

    $scope.date = new Date()
    $scope.time = new Date()
    $scope.time.setHours(12)
    $scope.time.setMinutes(0)

    $scope.events = []

    mapEvent= (event) ->
        return {
                content: event.description
                start: new Date(event.start)
            }

    EventService.getEvents($routeParams.userId, (events) ->

    	$scope.events = events.events.map(mapEvent)
    )

    $scope.createEvent = () ->

        dateTime = new Date(
            $scope.date.getFullYear(),
            $scope.date.getMonth(),
            $scope.date.getDate(),
            $scope.time.getHours(),
            $scope.time.getMinutes()
        )
        EventService.createEvent(
            {description: $scope.description
            start: dateTime.toString()},
            $routeParams.userId,
            (new_event) ->
                $scope.events.push(mapEvent(new_event)))

angular.module('timeline')
    .controller 'EventController', EventController