UsersController = ($scope, UsersService) ->

	UsersService.getUsers (users) ->
		$scope.users = users

	$scope.validationClass = (form, fieldName) ->
		'has-error': form[fieldName].$invalid and not form[fieldName].$pristine

	$scope.createUser = ($event) ->
		$event.preventDefault()
		UsersService.createUser $scope.newUser, (new_user) ->
			$scope.users.push(new_user)
			$scope.userForm.$setPristine()
			$scope.newUser = undefined




angular.module('timeline').controller 'UsersController', UsersController
