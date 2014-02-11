class UsersService
	constructor: (@http) ->

	getUsers: (callback) ->
		@http.get("/patient").success (data) -> callback(data)

	getUser: (id, callback) ->
		@http.get("/patient/#{id}").success (data) -> callback(data.patient)

	createUser: (user, callback) ->
		@http({
    		url: '/patient',
    		method: 'POST',
    		headers: { 'Content-Type': 'application/json' },
    		data: user
		}).success (data) -> callback(data)


angular.module('timeline').factory 'UsersService', ($http) -> new UsersService($http)
