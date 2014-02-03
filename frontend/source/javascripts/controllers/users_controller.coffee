UsersController = ($scope, UserService) ->

  	UserService.getUsers (users) ->
  		$scope.users = users


angular.module('timeline').controller 'UsersController', UsersController
