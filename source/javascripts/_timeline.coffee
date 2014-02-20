angular.module('timeline', [
    'ngRoute',
    'ui.bootstrap',
    'ngAnimate'
  ]
)

.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/users', {templateUrl: 'views/users.html', controller: 'UsersController'})
  $routeProvider.when('/activities/:userId', {templateUrl: 'views/activities.html', controller: 'ActivitiesController'})

  # $routeProvider.when('/users/:userId', {templateUrl: 'views/user/user.html', controller: 'UserController'})
  # $routeProvider.when('/users/:userId/activity/:activityId', {templateUrl: 'views/activity/activity.html', controller: "ActivityController"})

  $routeProvider.otherwise({redirectTo: '/users'})
])
