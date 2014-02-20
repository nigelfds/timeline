class ActivitiesService
	constructor: (@http) ->

	getActivities: (userId, callback) ->
		@http.get("/users/#{userId}/activities").success(callback)

	createActivity: (userId, values, callback) ->
		@http({
    		url: "/users/#{userId}/activities",
    		method: 'POST',
    		headers: { 'Content-Type': 'application/json' },
    		data: values
		}).success(callback).error((data) -> console.log data)


angular.module('timeline')
	.factory 'ActivitiesService', ($http) -> new ActivitiesService($http)
