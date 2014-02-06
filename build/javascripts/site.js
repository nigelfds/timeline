(function() {
  angular.module('timeline', ['ngRoute', 'ui.bootstrap']).config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/users', {
        templateUrl: 'users.html',
        controller: 'UsersController'
      });
      $routeProvider.when('/events/:userId', {
        templateUrl: 'events.html',
        controller: 'EventController'
      });
      return $routeProvider.otherwise({
        redirectTo: '/users'
      });
    }
  ]);

}).call(this);
(function() {
  var EventsService;

  EventsService = (function() {
    function EventsService(http) {
      this.http = http;
    }

    EventsService.prototype.getEvents = function(userId, callback) {
      return this.http.get("/patient/" + userId + "/event").success(callback);
    };

    EventsService.prototype.createEvent = function(event, userId) {
      return this.http({
        url: '/patient/' + userId + '/event',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        data: event
      });
    };

    return EventsService;

  })();

  angular.module('timeline').factory('EventService', function($http) {
    return new EventsService($http);
  });

}).call(this);
(function() {
  var UsersService;

  UsersService = (function() {
    function UsersService(http) {
      this.http = http;
    }

    UsersService.prototype.getUsers = function(callback) {
      return this.http.get("/patient").success(function(data) {
        return callback(data);
      });
    };

    UsersService.prototype.createUser = function(user, callback) {
      return this.http({
        url: '/patient',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        data: user
      }).success(function(data) {
        return callback(data);
      });
    };

    return UsersService;

  })();

  angular.module('timeline').factory('UsersService', function($http) {
    return new UsersService($http);
  });

}).call(this);
(function() {
  var EventController;

  EventController = function($scope, $routeParams, EventService) {
    $scope.date = new Date();
    $scope.time = new Date();
    $scope.time.setHours(12);
    $scope.time.setMinutes(0);
    EventService.getEvents($routeParams.userId, function(events) {
      return $scope.events = events.events.map(function(the_event) {
        return {
          content: the_event.description,
          start: new Date(the_event.start)
        };
      });
    });
    return $scope.createEvent = function() {
      var dateTime;
      dateTime = new Date($scope.date.getFullYear(), $scope.date.getMonth(), $scope.date.getDate(), $scope.time.getHours(), $scope.time.getMinutes());
      EventService.createEvent({
        description: $scope.description,
        start: dateTime.toString()
      }, $routeParams.userId);
      return $scope.events.push({
        content: $scope.description,
        start: dateTime
      });
    };
  };

  angular.module('timeline').controller('EventController', EventController);

}).call(this);
(function() {
  var UsersController;

  UsersController = function($scope, UsersService) {
    UsersService.getUsers(function(users) {
      return $scope.users = users;
    });
    return $scope.createUser = function() {
      var newUser;
      newUser = {
        name: $scope.userName
      };
      return UsersService.createUser(newUser, function(new_user) {
        return $scope.users.patients.push(new_user);
      });
    };
  };

  angular.module('timeline').controller('UsersController', UsersController);

}).call(this);
(function() {
  angular.module('timeline').directive('eventtimeline', [
    function() {
      return {
        restrict: 'E',
        template: '<div id="user-timeline">',
        link: function(scope, element, attrs) {
          var drawTimeline, options, timeline;
          timeline = new links.Timeline(element.children()[0]);
          options = {
            "width": "100%",
            "height": "400px",
            "style": "box",
            "groupsOnRight": "true"
          };
          timeline.draw([], options);
          drawTimeline = function(events) {
            timeline.setData(events);
            timeline.setVisibleChartRangeAuto();
            return timeline.zoom(-.1);
          };
          return scope.$watchCollection('events', function() {
            if (scope.events) {
              return drawTimeline(scope.events);
            }
          });
        }
      };
    }
  ]);

}).call(this);
(function() {


}).call(this);
