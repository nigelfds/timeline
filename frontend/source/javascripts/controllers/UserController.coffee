angular.module('timeline')
  .controller 'UserController', ($scope, UserService) ->
  	UserService.getUsers()
  	$scope.users = []