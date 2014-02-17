class ActivityService
	
	constructor: (@http) ->

	createActivity: (userId, data, callback) ->

	updateActivity: (id, data, callback) ->


angular.module('timeline')
	.factory 'ActivityService', ($http) -> new ActivityService($http)
