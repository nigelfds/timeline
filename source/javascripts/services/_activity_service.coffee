class ActivityService

  constructor: (@http) ->

  getActivity: (activityId, callback) ->
    @http.get("/activities/#{activityId}")


  createActivity: (data, callback) ->
    options = headers: 'Content-Type': 'application/json'
    @http.post("/activities", data, options)
       .success((new_activity) -> callback(new_activity))

  updateActivity: (id, data, callback) ->

angular.module('timeline')
  .factory 'ActivityService', ($http) -> new ActivityService($http)
