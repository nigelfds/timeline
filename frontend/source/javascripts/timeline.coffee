angular.module('timeline', [
		'ngRoute'
	]
)

.config(['$routeProvider', ($routeProvider) ->
	$routeProvider.when('/users', {templateUrl: 'users.html', controller: 'UserController'})
	$routeProvider.when('/events/:userId', {templateUrl: 'events.html', controller: 'EventController'})
	$routeProvider.otherwise({redirectTo: '/users'})
])
