class UsersService
  constructor: (@http) ->

  getUsers: (callback) ->
    @http.get("/users").success (data) -> callback(data)

  getUser: (id, callback) ->
    @http.get("/users/#{id}").success (data) -> callback(data)

  createUser: (user, callback) ->
    options = headers: 'Content-Type': 'application/json'

    @http.post("/users", user, options)
       .success (data) -> callback(data)

  updateUser: (id, data, callback) ->
    @http.put("/users/#{id}", data)
       .success -> callback(true)


angular.module('timeline').factory 'UsersService', ($http) -> new UsersService($http)
