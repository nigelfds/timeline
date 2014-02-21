ActivitiesController = ($scope, $routeParams, $timeout, ActivitiesService) ->
  userId = $routeParams.userId
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

  $scope.select = (index) ->
    $scope.selectedActivity = $scope.activities[index]

  $scope.new = ->
    default_values =
      date: new Date(Date.now())
      description: "New Activity"
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
      $scope.select(0)

  ActivitiesService.getActivities userId, (activities) ->
    addActivity(activity) for activity in activities
    $scope.select(0)



  # timeline stuff (NOT TESTED YET)

  # onChanges = (newValue, oldValue) ->  updateTimeline()
  # $scope.$watch "activities", onChanges, true

  # mapToTimeline = (activity) ->
  #   start: new Date(activity.date)
  #   content: activity.description

  # updateTimeline = ->
  #   timelineData = $scope.activities.map mapToTimeline
  #   timeline.setData timelineData
  #   timeline.setVisibleChartRangeAuto()
  #   timeline.zoom(-.2)

  # timeline = new links.Timeline(angular.element("#timeline")[0])
  # options =
  #   "width":  "100%"
  #   "height": "400px"
  #   "style": "box"

  # timeline.draw [], options

  # onSelect =  ->
  #   selection = timeline.getSelection()
  #   console.log typeof selection
  #   if selection.length > 0
  #     $scope.select selection[0].row
  #     $scope.$digest()

  # links.events.addListener timeline, 'select', onSelect


angular.module('timeline')
  .controller 'ActivitiesController', ActivitiesController