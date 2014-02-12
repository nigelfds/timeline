UserController = ($scope, $routeParams, UsersService) ->
	userId = $routeParams.userId

	UsersService.getUser userId, (user) ->
		$scope.user = user

	$scope.save = ($event) ->
		data = "numberOfHandovers": $scope.user.numberOfHandovers
		UsersService.updateUser userId, data

angular.module('timeline')
    .controller 'UserController', UserController