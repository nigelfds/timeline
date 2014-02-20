ActivitiesController = ($scope, $routeParams, ActivitiesService) ->

    $scope.date = new Date()
    $scope.time = new Date()
    $scope.time.setHours(12)
    $scope.time.setMinutes(0)

    $scope.activities = []

    mapToTimeline = (activity) ->
        start: new Date(activity.date)
        content: activity.description

    ActivitiesService.getActivities $routeParams.userId, (activities) ->
        $scope.activities = activities.map(mapToTimeline)

    $scope.createActivity = ->
        console.log "need to include $event here"

        dateTime = new Date(
            $scope.date.getFullYear(),
            $scope.date.getMonth(),
            $scope.date.getDate(),
            $scope.time.getHours(),
            $scope.time.getMinutes()
        )
        values = date: dateTime.toString(), description: $scope.description
        ActivitiesService.createActivity $routeParams.userId, values, (new_activity) ->
            $scope.activities.push mapToTimeline(new_activity)

angular.module('timeline')
    .controller 'ActivitiesController', ActivitiesController