ActivitiesController = ($scope, $routeParams, $timeout, ActivitiesService) ->
  userId = $routeParams.userId
  $scope.alerts = []

  ActivitiesService.getActivities userId, (activities) ->
    $scope.activities = activities
    $scope.selectedActivity = activities[0]

  $scope.select = (index) ->
    $scope.selectedActivity = $scope.activities[index]

  $scope.new = ->
    default_values =
      date: new Date(Date.now())
      description: "New Activity"
    ActivitiesService.createActivity userId, default_values, (new_activity) ->
      $scope.activities.push new_activity
      $scope.selectedActivity = new_activity

  $scope.save = ->
    activityId = $scope.selectedActivity._id.$oid
    values = {}
    for property, value of $scope.selectedActivity when property isnt "_id" and property isnt "user_id"
      values[property] = value 
    ActivitiesService.updateActivity userId, activityId, values, (success) ->
      addAlert "Updated successfully"

  $scope.delete = ->
    activityId = $scope.selectedActivity._id.$oid
    ActivitiesService.deleteActivity userId, activityId, (success) ->
      $scope.activities.splice($scope.activities.indexOf($scope.selectedActivity), 1)
      $scope.select(0)

  addAlert= (alert) ->
    $scope.alerts.push alert  
    $timeout(removeAlert, 5000)
  removeAlert = ->
    $scope.alerts.shift()


angular.module('timeline')
  .controller 'ActivitiesController', ActivitiesController