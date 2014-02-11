UserController = ($scope, $routeParams, UsersService) ->

	UsersService.getUser $routeParams.userId, (user) ->
		$scope.name = user.name

angular.module('timeline')
    .controller 'UserController', UserController