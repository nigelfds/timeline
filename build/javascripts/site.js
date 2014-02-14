(function() {
  angular.module('timeline', ['ngRoute', 'ui.bootstrap', 'ngAnimate']).config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/users', {
        templateUrl: 'users.html',
        controller: 'UsersController'
      });
      $routeProvider.when('/users/:userId', {
        templateUrl: 'user.html',
        controller: 'UserController'
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

    EventsService.prototype.createEvent = function(event, userId, callback) {
      return this.http({
        url: '/patient/' + userId + '/event',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        data: event
      }).success(callback);
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
      return this.http.get("/users").success(function(data) {
        return callback(data);
      });
    };

    UsersService.prototype.getUser = function(id, callback) {
      return this.http.get("/users/" + id).success(function(data) {
        return callback(data);
      });
    };

    UsersService.prototype.createUser = function(user, callback) {
      return this.http({
        url: '/users',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        data: user
      }).success(function(data) {
        return callback(data);
      });
    };

    UsersService.prototype.updateUser = function(id, data, callback) {
      this.http.put("/users/" + id, data);
      return callback(true);
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
    var mapEvent;
    $scope.date = new Date();
    $scope.time = new Date();
    $scope.time.setHours(12);
    $scope.time.setMinutes(0);
    $scope.events = [];
    mapEvent = function(event) {
      return {
        content: event.description,
        start: new Date(event.start)
      };
    };
    EventService.getEvents($routeParams.userId, function(events) {
      return $scope.events = events.events.map(mapEvent);
    });
    return $scope.createEvent = function() {
      var dateTime;
      dateTime = new Date($scope.date.getFullYear(), $scope.date.getMonth(), $scope.date.getDate(), $scope.time.getHours(), $scope.time.getMinutes());
      return EventService.createEvent({
        description: $scope.description,
        start: dateTime.toString()
      }, $routeParams.userId, function(new_event) {
        return $scope.events.push(mapEvent(new_event));
      });
    };
  };

  angular.module('timeline').controller('EventController', EventController);

}).call(this);
(function() {
  var UserController;

  UserController = function($scope, $routeParams, UsersService, $timeout) {
    var addAlert, userId;
    userId = $routeParams.userId;
    UsersService.getUser(userId, function(user) {
      return $scope.user = user;
    });
    $scope.validationClass = function(form, fieldName) {
      return {
        'has-success': form[fieldName].$valid,
        'has-error': form[fieldName].$invalid
      };
    };
    $scope.save = function(form, property) {
      var data, formValue;
      formValue = form[property];
      if (formValue != null ? formValue.$valid : void 0) {
        data = {};
        data[property] = $scope.user[property];
        return UsersService.updateUser(userId, data, function(success) {
          return addAlert("Updated user successfully");
        });
      } else {
        return addAlert("Invalid value.  User wasn't updated.");
      }
    };
    $scope.alerts = [];
    return addAlert = function(_message) {
      var removeAlert;
      $scope.alerts.push({
        message: _message
      });
      removeAlert = function() {
        return $scope.alerts.shift();
      };
      return $timeout(removeAlert, 5000);
    };
  };

  angular.module('timeline').controller('UserController', UserController);

}).call(this);
(function() {
  var UsersController;

  UsersController = function($scope, UsersService) {
    UsersService.getUsers(function(users) {
      return $scope.users = users;
    });
    $scope.validationClass = function(form, fieldName) {
      return {
        'has-error': form[fieldName].$invalid && (!form[fieldName].$pristine)
      };
    };
    return $scope.createUser = function($event) {
      var newUser;
      $event.preventDefault();
      newUser = {
        name: $scope.userName,
        urNumber: $scope.urNumber,
        age: $scope.age,
        gender: $scope.gender
      };
      $scope.userName = void 0;
      $scope.urNumber = void 0;
      $scope.age = void 0;
      $scope.gender = void 0;
      $scope.userForm.$setPristine();
      return UsersService.createUser(newUser, function(new_user) {
        return $scope.users.push(new_user);
      });
    };
  };

  angular.module('timeline').controller('UsersController', UsersController);

}).call(this);
(function() {
  angular.module('timeline').directive('eventtimeline', [
    function() {
      return {
        restrict: 'A',
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
