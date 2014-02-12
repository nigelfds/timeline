UserController = ($scope, $routeParams, UsersService) ->
	userId = $routeParams.userId

	UsersService.getUser userId, (user) -> $scope.user = user

	$scope.validationClass = (form, fieldName) -> 
		'has-success': form[fieldName].$valid
		'has-error': form[fieldName].$invalid
		'has-warning': form[fieldName].$valid and form.$invalid

	$scope.save = () ->
		return if $scope.userForm.$invalid
		# filter all the user data except the id
		data = {}
		for property, value of $scope.user when property != "_id"
			data[property] = value

		UsersService.updateUser userId, data

	$scope.log = ->
		console.log($scope.user) unless $scope.userForm.$invalid



angular.module('timeline')
    .controller 'UserController', UserController