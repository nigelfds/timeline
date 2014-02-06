class EventsService
	constructor: (@http) ->



	getEvents: (userId,callback) ->
		@http.get("/patient/#{userId}/event").success(callback)

	createEvent: (event, userId) ->
		@http({
    		url: '/patient/'+userId+'/event',
    		method: 'POST',
    		headers: { 'Content-Type': 'application/json' },
    		data: event
		})


angular.module('timeline')
	.factory 'EventService', ($http) -> new EventsService($http)
