UsersController = ($scope, UsersService) ->

	UsersService.getUsers (users) ->
		$scope.users = users

	$scope.createUser=  ->
		newUser = {name: $scope.userName }
		UsersService.createUser newUser, (new_user) ->
			$scope.users.patients.push(new_user)



angular.module('timeline').controller 'UsersController', UsersController
