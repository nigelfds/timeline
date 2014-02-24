class EventsService
  constructor: (@http) ->

  getEvents: (userId, callback) ->
    @http.get("/users/#{userId}/activities").success(callback)

  createEvent: (event, userId, callback) ->
    @http({
        url: "/users/#{userId}/activities",
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        data: event
    }).success(callback).error((data) -> console.log data)


angular.module('timeline')
  .factory 'EventService', ($http) -> new EventsService($http)
