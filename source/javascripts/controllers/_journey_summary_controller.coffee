JourneySummaryController = ($scope) ->

  uniqueAcrossActivities = (name, activities) ->
    unique = []
    for activity in activities
      if activity[name]?
        for element in activity[name]
          unique.push element unless unique.indexOf(element) != -1
    unique

  $scope.numberOfStaffInvolved = (activities) ->
    uniqueAcrossActivities("staffInvolved", activities).length

  $scope.numberOfITSystemUpdated = (activities) ->
    uniqueAcrossActivities("itSystems", activities).length

  $scope.countOfITSystemUpdates = (activities) ->
    sum = 0
    for activity in activities
      sum += activity.itSystems.length if activity.itSystems
    sum

  $scope.numberOfPaperRecordUpdated = (activities) ->
    uniqueAcrossActivities("paperRecords", activities).length

  $scope.countOfPaperRecordUpdates = (activities) ->
    sum = 0
    for activity in activities
      sum += activity.paperRecords.length if activity.paperRecords
    sum

  numOccurrenceOf = (name, activities) ->
    occurrence = 0
    for activity in activities
      occurrence += 1 if activity[name]
    occurrence

  $scope.numberOfHandoffs = (activities) ->
    numOccurrenceOf( "involveHandoff", activities)

  $scope.numberOfContacts = (activities) ->
    numOccurrenceOf( "involveContact", activities)

  $scope.numberOfTherapeuticContributions = (activities) ->
    sum = 0
    for activity in activities
      sum++ if activity.isAPM and activity.contributesTherapeutically
    sum

  $scope.numberOfAPMActivities = (activities) ->
    numOccurrenceOf( "isAPM", activities)


angular.module('timeline')
  .controller 'JourneySummaryController', JourneySummaryController
