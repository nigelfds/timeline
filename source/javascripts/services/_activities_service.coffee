class ActivitiesService
  constructor: (@http) ->

  getActivities: (userId, callback) ->
    @http.get("/users/#{userId}/activities").success(callback)

  createActivity: (userId, values, callback) ->
    @http.post("/users/#{userId}/activities", values).success(callback)

  updateActivity: (userId, activityId, values, callback) ->
    @http.put("/users/#{userId}/activities/#{activityId}", values).success -> callback(true)

angular.module('timeline')
  .factory 'ActivitiesService', ($http) -> new ActivitiesService($http)
