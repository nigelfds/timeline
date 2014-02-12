class UsersService
	constructor: (@http) ->

	getUsers: (callback) ->
		@http.get("/users").success (data) -> callback(data)

	getUser: (id, callback) ->
		@http.get("/users/#{id}").success (data) -> callback(data)

	createUser: (user, callback) ->
		@http({
    		url: '/users',
    		method: 'POST',
    		headers: { 'Content-Type': 'application/json' },
    		data: user
		}).success (data) -> callback(data)

	updateUser: (id, data) ->
		@http.put("/users/#{id}", data)


angular.module('timeline').factory 'UsersService', ($http) -> new UsersService($http)
