#angular.module("timeline").controller 

UsersController = ($scope, users_service) ->



	$scope.users = users_service.items()

class UsersService
	items : ->