UserController = ($scope, $routeParams, UsersService) ->
	userId = $routeParams.userId

	UsersService.getUser userId, (user) -> $scope.user = user

	$scope.save = ($event) ->		
		# filter all the user data except the id
		data = {}
		data[property] = value for property, value of $scope.user when property != "_id"

		UsersService.updateUser userId, data

angular.module('timeline')
    .controller 'UserController', UserController