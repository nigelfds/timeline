angular.module('timeline', [
    'ngRoute',
    'ui.bootstrap',
    'ngAnimate'
  ]
)

.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/users', {templateUrl: 'users.html', controller: 'UsersController'})
  $routeProvider.when('/users/:userId', {templateUrl: 'views/user/user.html', controller: 'UserController'})
  $routeProvider.when('/events/:userId', {templateUrl: 'events.html', controller: 'EventController'})

  $routeProvider.when('/users/:userId/activity/:activityId', {templateUrl: 'views/activity/activity.html', controller: "ActivityController"})

  $routeProvider.otherwise({redirectTo: '/users'})
])
