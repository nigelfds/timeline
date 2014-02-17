ActivityController = ($scope, $routeParams) ->
	$scope.activityType = $routeParams.activityType

angular.module('timeline')
    .controller 'ActivityController', ActivityController