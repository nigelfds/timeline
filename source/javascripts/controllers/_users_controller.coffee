UsersController = ($scope, UsersService) ->

	UsersService.getUsers (users) ->
		$scope.users = users

	$scope.createUser = ($event) ->
		$event.preventDefault()
		newUser = { name: $scope.userName }
		$scope.userName = undefined
		UsersService.createUser newUser, (new_user) -> $scope.users.push(new_user)


angular.module('timeline').controller 'UsersController', UsersController
