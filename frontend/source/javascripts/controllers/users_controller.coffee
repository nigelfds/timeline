UsersController = ($scope, UsersService) ->

  	UsersService.getUsers (users) ->
  		$scope.users = users


angular.module('timeline').controller 'UsersController', UsersController
