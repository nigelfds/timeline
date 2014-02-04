UsersController = ($scope, UsersService) ->

  	UsersService.getUsers (users) ->
  		console.log "users : #{users}"
  		$scope.users = users


angular.module('timeline').controller 'UsersController', UsersController
