UsersController = ($scope, UsersService) ->

	UsersService.getUsers (users) ->
		$scope.users = users

	$scope.validationClass = (form, fieldName) ->
		'has-error': form[fieldName].$invalid && (! form[fieldName].$pristine)

	$scope.createUser = ($event) ->
		$event.preventDefault()
		newUser = {
			name: $scope.userName
			urNumber: $scope.urNumber
			age: $scope.age
			gender: $scope.gender
		}
		$scope.userName = undefined
		$scope.urNumber = undefined
		$scope.age = undefined
		$scope.gender = undefined

		$scope.userForm.$setPristine();

		UsersService.createUser newUser, (new_user) -> $scope.users.push(new_user)




angular.module('timeline').controller 'UsersController', UsersController
