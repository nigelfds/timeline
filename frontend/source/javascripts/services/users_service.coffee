class UsersService
	constructor: (@http) ->

	getUsers: (callback) ->
		@http.get("http://0.0.0.0:9292/patient").success(callback)

angular.module('timeline').factory 'UserService', ($http) -> new UsersService($http)
