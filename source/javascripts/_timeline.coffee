angular.module('timeline', [
		'ngRoute',
		'ui.bootstrap',
		'ngAnimate'
	]
)

.config(['$routeProvider', ($routeProvider) ->
	$routeProvider.when('/users', {templateUrl: 'users.html', controller: 'UsersController'})
	$routeProvider.when('/users/:userId', {templateUrl: 'user.html', controller: 'UserController'})
	$routeProvider.when('/events/:userId', {templateUrl: 'events.html', controller: 'EventController'})
	$routeProvider.otherwise({redirectTo: '/users'})
])
