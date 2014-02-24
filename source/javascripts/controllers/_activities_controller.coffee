ActivitiesController = ($scope, $routeParams, $timeout, ActivitiesService, UsersService) ->
  userId = $routeParams.userId

  UsersService.getUser userId, (user) ->
    $scope.user = user

  $scope.alerts = []
  $scope.activities = []

  addAlert = (alert) ->
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
    length = $scope.activities.length 
    defaultDate = moment(new Date(Date.now())).format("DD/MM/YYYY hh:mm A")    
    defaultDate = $scope.activities[length - 1].date if length > 0
    defaults = date: defaultDate, description: "New Activity"

    ActivitiesService.createActivity userId, defaults, (new_activity) ->
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

  $scope.numberOfHandoffs = (activities) ->
    sum = 0
    for activity in activities
      sum += 1 if activity.involveHandoff
    sum

  $scope.numberOfContacts = (activities) ->
    sum = 0
    for activity in activities
      sum += 1 if activity.involveContact
    sum

angular.module('timeline')
  .controller 'ActivitiesController', ActivitiesController
