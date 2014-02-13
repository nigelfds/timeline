UserController = ($scope, $routeParams, UsersService, $timeout) ->
	userId = $routeParams.userId

	UsersService.getUser userId, (user) -> $scope.user = user

	$scope.validationClass = (form, fieldName) -> 
		'has-success': form[fieldName].$valid
		'has-error': form[fieldName].$invalid
		# 'has-warning': form[fieldName].$valid and form.$invalid

	$scope.save = (property) ->
		formValue = $scope.userForm["#{property}"]
		if formValue?.$valid
			data = {}
			data[property] = $scope.user[property]
			UsersService.updateUser userId, data

	$scope.alerts = []
	$scope.addAlert = ->
		$scope.alerts.push msg: "Another alert!"
		removeAlert = -> $scope.alerts.shift()
		$timeout(removeAlert, 5000)

angular.module('timeline')
    .controller 'UserController', UserController