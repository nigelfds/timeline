class UsersService
	constructor: (@http) ->

	getUsers: (callback) ->
		@http.get("/user_list_api").success(callback)

angular.module('timeline')
	.factory 'UserService', ($http) -> new UsersService($http)
