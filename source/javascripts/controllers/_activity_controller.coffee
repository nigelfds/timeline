ActivityController = ($scope, $routeParams, ActivityService) ->
	activityId = $routeParams.activityId
	ActivityService.getActivity activityId, (activity) ->
		$scope.activityType = activity.activityType

angular.module('timeline')
    .controller 'ActivityController', ActivityController