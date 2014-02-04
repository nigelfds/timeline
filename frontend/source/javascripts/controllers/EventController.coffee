EventController = ($scope, $routeParams, EventService) ->
    EventService.getEvents($routeParams.userId, (events) ->
        $scope = events
    )

angular.module('timeline')
    .controller 'EventController', EventController