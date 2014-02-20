ActivitiesController = ($scope, $routeParams, ActivitiesService) ->
    $scope.currentActivity = {}

    mapToTimeline = (activity) ->
        start: new Date(activity.date)
        content: activity.description

    ActivitiesService.getActivities $routeParams.userId, (activities) ->
        $scope.activities = activities
        $scope.timelineData = activities.map(mapToTimeline)

    $scope.newActivity = ->
        now = new Date(Date.now())
        values = date: now.toString(), description: "New Activity"
        ActivitiesService.createActivity $routeParams.userId, values, (new_activity) ->
            $scope.activities.push new_activity
            $scope.timelineData.push mapToTimeline(new_activity)
            $scope.currentActivity = new_activity

    $scope.saveActivity = ->
        activityId = $scope.currentActivity._id.$oid
        values = {}
        values[property] = value for property, value of $scope.currentActivity when property != "_id"

        ActivitiesService.updateActivity $routeParams.userId, activityId, values, (success) ->
            console.log "success"

    $scope.selectActivity = (activity) ->
        $scope.description = activity.description
        console.log $scope.description

    # $scope.createActivity = ->
    #     console.log "need to include $event here"

    #     dateValue = new Date(
    #         $scope.date.getFullYear(),
    #         $scope.date.getMonth(),
    #         $scope.date.getDate(),
    #         $scope.time.getHours(),
    #         $scope.time.getMinutes()
    #     )
    #     values = date: dateValue.toString(), description: $scope.description
    #     ActivitiesService.createActivity $routeParams.userId, values, (new_activity) ->
    #         $scope.activities.push mapToTimeline(new_activity)

angular.module('timeline')
    .controller 'ActivitiesController', ActivitiesController