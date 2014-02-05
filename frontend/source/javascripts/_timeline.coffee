angular.module('timeline', [
		'ngRoute',
		'ui.bootstrap'
	]
)

.config(['$routeProvider', ($routeProvider) ->
	$routeProvider.when('/users', {templateUrl: 'users.html', controller: 'UsersController'})
	$routeProvider.when('/events/:userId', {templateUrl: 'events.html', controller: 'EventController'})
	$routeProvider.otherwise({redirectTo: '/users'})
])
