UsersController = ($scope, UsersService) ->

	UsersService.getUsers (users) ->
		$scope.users = users.patients

	$scope.createUser = ($event) ->
		$event.preventDefault()
		newUser = { name: $scope.userName }
		UsersService.createUser newUser, (new_user) -> $scope.users.push(new_user)

angular.module('timeline').controller 'UsersController', UsersController
