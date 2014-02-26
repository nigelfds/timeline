ActivitiesController = ($scope, $routeParams, $timeout, ActivitiesService, UsersService) ->
  userId = $routeParams.userId

  UsersService.getUser userId, (user) ->
    $scope.user = user

  $scope.alerts = []
  $scope.activities = []

  $scope.selectAllOnClick = (_event) -> _event.target.select()

  $scope.addNewStaffInvolved = ->
    $scope.selectedActivity.staffInvolved = [] if $scope.selectedActivity.staffInvolved is undefined
    unless $scope.selectedActivity.staffInvolved.indexOf($scope.newStaffName) != -1
      $scope.selectedActivity.staffInvolved.push $scope.newStaffName
      $scope.save()
    else
      addAlert "Existing Staff Member Name!"

  $scope.removeStaffInvolved = (staffName) ->
    index = $scope.selectedActivity.staffInvolved.indexOf staffName
    $scope.selectedActivity.staffInvolved.splice index, 1
    $scope.save()

  uniqueStaffInvolved = (activities) ->
    staff = []
    for activity in activities
      if activity.staffInvolved?
        for staffName in activity.staffInvolved
          staff.push staffName unless staff.indexOf(staffName) != -1
    staff

  $scope.addNewITSystem = ->
    $scope.selectedActivity.itSystems = [] if $scope.selectedActivity.itSystems is undefined
    unless $scope.selectedActivity.itSystems.indexOf($scope.newITSystemName) != -1
      $scope.selectedActivity.itSystems.push $scope.newITSystemName
      $scope.save()
    else
      addAlert "Duplicated IT System name"

  $scope.removeITSystem = (systemName) ->
    index = $scope.selectedActivity.itSystems.indexOf systemName
    $scope.selectedActivity.itSystems.splice index, 1
    $scope.save()

  uniqueITSystems = (activities) ->
    systems = []
    for activity in activities
      if activity.itSystems?
        for systemName in activity.itSystems
          systems.push systemName unless systems.indexOf(systemName) != -1
    systems

  $scope.itSystemsUpdated = (activities) ->
    uniqueITSystems activities

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
      $scope.newStaffName = ""
      $scope.newITSystemName = ""
      $scope.staffInvolved = uniqueStaffInvolved($scope.activities)

  $scope.delete = ->
    activityId = $scope.selectedActivity._id.$oid
    ActivitiesService.deleteActivity userId, activityId, (success) ->
      removeActivity $scope.selectedActivity
      $scope.select undefined

  ActivitiesService.getActivities userId, (activities) ->
    addActivity(activity) for activity in activities
    $scope.select activities[0]
    $scope.staffInvolved = uniqueStaffInvolved($scope.activities)

angular.module('timeline')
  .controller 'ActivitiesController', ActivitiesController
