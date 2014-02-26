JourneySummaryController = ($scope) ->
 
  uniqueStaffInvolved = (activities) ->
    staff = []
    for activity in activities
      if activity.staffInvolved?
        for staffName in activity.staffInvolved
          staff.push staffName unless staff.indexOf(staffName) != -1
    staff

  $scope.numberOfStaffInvolved = (activities) ->
    uniqueStaffInvolved(activities).length

  uniqueITSystems = (activities) ->
    systems = []
    for activity in activities
      if activity.itSystems?
        for systemName in activity.itSystems
          systems.push systemName unless systems.indexOf(systemName) != -1
    systems

  $scope.numberOfITSystemUpdated = (activities) ->
    uniqueITSystems(activities).length

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


  $scope.numberOfTherapeuticContributions = (activities) ->
    sum = 0
    for activity in activities
      sum++ if activity.isAPM and activity.contributesTherapeutically
    sum

  $scope.numberOfAPMActivities = (activities) ->
    sum = 0
    for activity in activities
      sum++ if activity.isAPM
    sum

angular.module('timeline')
  .controller 'JourneySummaryController', JourneySummaryController
