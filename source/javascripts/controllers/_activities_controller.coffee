ActivitiesController = ($scope, $routeParams, ActivitiesService) ->
  userId = $routeParams.userId

  ActivitiesService.getActivities userId, (activities) ->
    $scope.activities = activities
    $scope.selectedActivity = activities[0]

  $scope.select = (index) ->
    $scope.selectedActivity = $scope.activities[index]

  $scope.save = ->
    activityId = $scope.selectedActivity._id.$oid
    values = {}
    for property, value of $scope.selectedActivity when property isnt "_id" and property isnt "user_id"
      console.log property
      values[property] = value 
    console.log values
    ActivitiesService.updateActivity userId, activityId, values, (success) ->
      console.log "saved"

angular.module('timeline')
  .controller 'ActivitiesController', ActivitiesController