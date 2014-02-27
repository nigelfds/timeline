class UsersService
  constructor: (@http) ->

  getUsers: (callback) ->
    @http.get("/users").success (data) -> callback(data)

  getUser: (id, callback) ->
    @http.get("/users/#{id}").success (data) -> callback(data)

  createUser: (user, callback) ->
    # options = headers: 'Content-Type': 'application/json'
    onSuccess = (data) -> callback success: true, user: data
    onError = (data) -> callback success: false, message: data

    @http.post("/users", user).success(onSuccess).error(onError)

  updateUser: (id, data, callback) ->
    onSuccess = (data) -> callback success: true
    onError = (data) -> callback success: false, message: data
    @http.put("/users/#{id}", data).success(onSuccess).error(onError)


angular.module('timeline').factory 'UsersService', ($http) -> new UsersService($http)
