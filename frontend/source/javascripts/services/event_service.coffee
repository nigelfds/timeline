class EventsService
	constructor: (@http) ->

	getEvents: (userId,callback) ->
		@http.get("http://0.0.0.0:9292/patient/#{userId}/event").success(callback)

angular.module('timeline')
	.factory 'EventService', ($http) -> new EventsService($http)
