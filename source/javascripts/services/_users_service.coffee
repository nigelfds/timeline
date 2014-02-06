class UsersService
	constructor: (@http) ->

	getUsers: (callback) ->
		@http.get("/patient").success (data) -> callback(data)

	createUser: (user, callback) ->
		@http({
    		url: '/patient',
    		method: 'POST',
    		headers: { 'Content-Type': 'application/json' },
    		data: user
		}).success (data) -> callback(data)


angular.module('timeline').factory 'UsersService', ($http) -> new UsersService($http)
