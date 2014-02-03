angular.module('timeline', [
		'ngRoute'
	]
)

.config(['$routeProvider', ($routeProvider) ->
	$routeProvider.when('/users', {templateUrl: 'users.html', controller: 'UserController'})
	$routeProvider.otherwise({redirectTo: '/users'})
])
