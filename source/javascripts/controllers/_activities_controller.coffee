ActivitiesController = ($scope, $routeParams, $timeout, ActivitiesService, UsersService) ->
  userId = $routeParams.userId

  UsersService.getUser userId, (user) ->
    $scope.user = user

  $scope.alerts = []
  $scope.activities = []

  addAlert= (alert) ->
    $scope.alerts.push alert  
    $timeout(removeAlert, 5000)
  removeAlert = ->
    $scope.alerts.shift()

  addActivity = (new_activity) ->
    $scope.activities.push new_activity

  removeActivity = (activity) ->
    $scope.activities.splice($scope.activities.indexOf(activity), 1)

  $scope.select = (activity) ->
    $scope.selectedActivity = activity

  $scope.new = ->
    now = moment(new Date(Date.now())).format("DD/MM/YYYY hh:mm A")
    default_values = date: now, description: "New Activity"
    ActivitiesService.createActivity userId, default_values, (new_activity) ->
      addActivity new_activity
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
      removeActivity $scope.selectedActivity
      $scope.select undefined

  ActivitiesService.getActivities userId, (activities) ->
    addActivity(activity) for activity in activities
    $scope.select activities[0]

angular.module('timeline')
  .controller 'ActivitiesController', ActivitiesController