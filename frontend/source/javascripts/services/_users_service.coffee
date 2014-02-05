class UsersService
	constructor: (@http) ->

	getUsers: (callback) ->
		@http.get("http://0.0.0.0:9292/patient").success (data) -> callback(data)

	createUser: (user, callback) ->
		@http({
    		url: 'http://0.0.0.0:9292/patient',
    		method: 'POST',
    		headers: { 'Content-Type': 'application/json' },
    		data: user
		}).success (data) -> callback(data)


angular.module('timeline').factory 'UsersService', ($http) -> new UsersService($http)
