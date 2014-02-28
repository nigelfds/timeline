ActivitiesController = ($scope, $routeParams, $timeout, ActivitiesService, UsersService) ->
  userId = $routeParams.userId

  UsersService.getUser userId, (user) ->
    $scope.user = user

  $scope.alerts = new MessagesList($timeout)
  addAlert = (text, type) -> $scope.alerts.add text, type
  
  $scope.activities = []

  $scope.selectAllOnClick = (_event) -> _event.target.select()

  uniqueAcrossActivities = (name, activities) ->
    unique = []
    for activity in activities
      if activity[name]?
        for element in activity[name]
          unique.push element unless unique.indexOf(element) != -1
    unique

  $scope.addNewStaffInvolved = ->
    $scope.selectedActivity.staffInvolved = [] if $scope.selectedActivity.staffInvolved is undefined
    unless $scope.selectedActivity.staffInvolved.indexOf($scope.newStaffName) != -1
      $scope.selectedActivity.staffInvolved.push $scope.newStaffName
      $scope.save()
    else
      addAlert "Existing Staff Member Name!", "danger"

  $scope.removeStaffInvolved = (staffName) ->
    index = $scope.selectedActivity.staffInvolved.indexOf staffName
    $scope.selectedActivity.staffInvolved.splice index, 1
    $scope.save()

  $scope.staffInvolved = (activities) ->
    uniqueAcrossActivities("staffInvolved", activities)

  $scope.addNewITSystem = ->
    $scope.selectedActivity.itSystems = [] if $scope.selectedActivity.itSystems is undefined
    unless $scope.selectedActivity.itSystems.indexOf($scope.newITSystemName) != -1
      $scope.selectedActivity.itSystems.push $scope.newITSystemName
      $scope.save()
    else
      addAlert "Duplicated IT System name", "danger"

  $scope.removeITSystem = (systemName) ->
    index = $scope.selectedActivity.itSystems.indexOf systemName
    $scope.selectedActivity.itSystems.splice index, 1
    $scope.save()

  $scope.itSystemsUpdated = (activities) ->
    uniqueAcrossActivities("itSystems", activities)

  $scope.addNewPaperRecord = ->
    $scope.selectedActivity.paperRecords = [] if $scope.selectedActivity.paperRecords is undefined
    unless $scope.selectedActivity.paperRecords.indexOf($scope.newPaperRecord) != -1
      $scope.selectedActivity.paperRecords.push $scope.newPaperRecord
      $scope.save()
    else
      addAlert "Duplicated Paper Record name", "danger"

  $scope.removePaperRecord = (paperRecordName) ->
    index = $scope.selectedActivity.paperRecords.indexOf paperRecordName
    $scope.selectedActivity.paperRecords.splice index, 1
    $scope.save()

  $scope.paperRecordslist = (activities) ->
    uniqueAcrossActivities("paperRecords", activities)

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
      $scope.edit()

  $scope.save = (andClose) ->
    activityId = $scope.selectedActivity._id.$oid
    values = {}
    for property, value of $scope.selectedActivity when property isnt "_id" and property isnt "user_id"
      values[property] = value
    ActivitiesService.updateActivity userId, activityId, values, (success) ->
      addAlert "Updated successfully", "success"
      $scope.newStaffName = ""
      $scope.newITSystemName = ""
      $scope.newPaperRecord = ""
      angular.element('#selectedActivity').modal("hide") if andClose

  $scope.edit = ->
    angular.element('#selectedActivity').modal('show')

  $scope.delete = ->
    result = confirm "Are you sure you want to delete this activity?"
    if result
      activityId = $scope.selectedActivity._id.$oid
      ActivitiesService.deleteActivity userId, activityId, (success) ->
        angular.element('#selectedActivity').modal("hide");
        removeActivity $scope.selectedActivity
        $scope.select undefined
        addAlert "Activity deleted", "warning"

  ActivitiesService.getActivities userId, (activities) ->
    addActivity(activity) for activity in activities
    $scope.select activities[0]

angular.module('timeline')
  .controller 'ActivitiesController', ActivitiesController
