angular.module('timeline')
	.factory 'UserService', ($http)->
		getUsers: (callback) ->
			$http.get("/user_list_api").success(callback)
