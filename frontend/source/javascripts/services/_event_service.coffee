class EventsService
	constructor: (@http) ->



	getEvents: (userId,callback) ->
		@http.get("http://0.0.0.0:9292/patient/#{userId}/event").success(callback)

	createEvent: (event, userId) ->
		@http({
    		url: 'http://0.0.0.0:9292/patient/'+userId+'/event',
    		method: 'POST',
    		headers: { 'Content-Type': 'application/json' },
    		data: event
		})


angular.module('timeline')
	.factory 'EventService', ($http) -> new EventsService($http)
