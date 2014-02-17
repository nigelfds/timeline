UserController = ($scope, $routeParams, UsersService, $timeout, $location, ActivityService) ->
	userId = $routeParams.userId

	UsersService.getUser userId, (user) -> $scope.user = user

	$scope.validationClass = (form, fieldName) ->
		'has-success': form[fieldName].$valid
		'has-error': form[fieldName].$invalid

	$scope.save = (form, property) ->
		formValue = form[property]
		if formValue?.$valid
			data = {}
			data[property] = $scope.user[property]
			UsersService.updateUser userId, data, (success) ->
				addAlert "Updated user successfully"
		else
			addAlert "Invalid value.  User wasn't updated."

	$scope.alerts = []
	addAlert = (_message) ->
		$scope.alerts.push(message: _message)
		removeAlert = -> $scope.alerts.shift()
		$timeout(removeAlert, 5000)

	$scope.createActivity = (event, activityType) ->
		data = activityType: activityType

		ActivityService.createActivity userId, data, (newActivity) ->
			$location.path "/users/#{userId}/activity/#{newActivity._id.$oid}"

angular.module('timeline')
    .controller 'UserController', UserController