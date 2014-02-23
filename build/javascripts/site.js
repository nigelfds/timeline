(function() {
  angular.module('timeline', ['ngRoute', 'ui.bootstrap', 'ngAnimate']).config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/users', {
        templateUrl: 'views/users.html',
        controller: 'UsersController'
      });
      $routeProvider.when('/activities/:userId', {
        templateUrl: 'views/activities.html',
        controller: 'ActivitiesController'
      });
      return $routeProvider.otherwise({
        redirectTo: '/users'
      });
    }
  ]);

}).call(this);
(function() {
  var ActivitiesService;

  ActivitiesService = (function() {
    function ActivitiesService(http) {
      this.http = http;
    }

    ActivitiesService.prototype.getActivities = function(userId, callback) {
      return this.http.get("/users/" + userId + "/activities").success(callback);
    };

    ActivitiesService.prototype.createActivity = function(userId, values, callback) {
      return this.http.post("/users/" + userId + "/activities", values).success(callback);
    };

    ActivitiesService.prototype.updateActivity = function(userId, activityId, values, callback) {
      return this.http.put("/users/" + userId + "/activities/" + activityId, values).success(function() {
        return callback(true);
      });
    };

    ActivitiesService.prototype.deleteActivity = function(userId, activityId, callback) {
      return this.http["delete"]("/users/" + userId + "/activities/" + activityId).success(function() {
        return callback(true);
      });
    };

    return ActivitiesService;

  })();

  angular.module('timeline').factory('ActivitiesService', function($http) {
    return new ActivitiesService($http);
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
      var options;
      options = {
        headers: {
          'Content-Type': 'application/json'
        }
      };
      return this.http.post("/users", user, options).success(function(data) {
        return callback(data);
      });
    };

    UsersService.prototype.updateUser = function(id, data, callback) {
      return this.http.put("/users/" + id, data).success(function() {
        return callback(true);
      });
    };

    return UsersService;

  })();

  angular.module('timeline').factory('UsersService', function($http) {
    return new UsersService($http);
  });

}).call(this);
(function() {
  var ActivitiesController;

  ActivitiesController = function($scope, $routeParams, $timeout, ActivitiesService) {
    var addActivity, addAlert, removeActivity, removeAlert, userId;
    userId = $routeParams.userId;
    $scope.alerts = [];
    $scope.activities = [];
    addAlert = function(alert) {
      $scope.alerts.push(alert);
      return $timeout(removeAlert, 5000);
    };
    removeAlert = function() {
      return $scope.alerts.shift();
    };
    addActivity = function(new_activity) {
      return $scope.activities.push(new_activity);
    };
    removeActivity = function(activity) {
      return $scope.activities.splice($scope.activities.indexOf(activity), 1);
    };
    $scope.select = function(index) {
      return $scope.selectedActivity = $scope.activities[index];
    };
    $scope["new"] = function() {
      var default_values, now;
      now = moment(new Date(Date.now())).format("DD/MM/YYYY hh:mm A");
      default_values = {
        date: now,
        description: "New Activity"
      };
      return ActivitiesService.createActivity(userId, default_values, function(new_activity) {
        addActivity(new_activity);
        return $scope.selectedActivity = new_activity;
      });
    };
    $scope.save = function() {
      var activityId, property, value, values, _ref;
      activityId = $scope.selectedActivity._id.$oid;
      values = {};
      _ref = $scope.selectedActivity;
      for (property in _ref) {
        value = _ref[property];
        if (property !== "_id" && property !== "user_id") {
          values[property] = value;
        }
      }
      return ActivitiesService.updateActivity(userId, activityId, values, function(success) {
        return addAlert("Updated successfully");
      });
    };
    $scope["delete"] = function() {
      var activityId;
      activityId = $scope.selectedActivity._id.$oid;
      return ActivitiesService.deleteActivity(userId, activityId, function(success) {
        removeActivity($scope.selectedActivity);
        return $scope.select(0);
      });
    };
    return ActivitiesService.getActivities(userId, function(activities) {
      var activity, _i, _len;
      for (_i = 0, _len = activities.length; _i < _len; _i++) {
        activity = activities[_i];
        addActivity(activity);
      }
      return $scope.select(0);
    });
  };

  angular.module('timeline').controller('ActivitiesController', ActivitiesController);

}).call(this);
(function() {
  var Basis32Controller;

  Basis32Controller = function($scope, $routeParams) {
    return $scope.questions = [
      {
        text: "Managing day to day life (e.g. Getting to places on time, handling money, making everyday decisions)"
      }, {
        text: "Household responsibilities (e.g. Shopping, cooking, laundry, keeping room clean, other chores)"
      }, {
        text: "Work (e.g. Completing tasks, performance level, finding / keeping a job)"
      }, {
        text: "School (e.g. academic performance, completing assignments, attendance)"
      }, {
        text: "Leisure time or recreational activities"
      }, {
        text: "Adjusting to major life stresses (e.g. separation, divorce, moving, new job, new school, a death)"
      }, {
        text: "Relationships with family members"
      }, {
        text: "Getting along with people outside of the family"
      }, {
        text: "Isolation or feelings of loneliness"
      }, {
        text: "Being able to feel close to others"
      }, {
        text: "Being realistic about yourself to others"
      }, {
        text: "Recognising and expressing emotions appropriately"
      }, {
        text: "Developing indepencence, autonomy"
      }, {
        text: "Goals or direction of life"
      }, {
        text: "Lack of self-confidence, feeling bad about yourself"
      }
    ];
  };

}).call(this);
(function() {
  var UsersController;

  UsersController = function($scope, UsersService) {
    UsersService.getUsers(function(users) {
      return $scope.users = users;
    });
    $scope.validationClass = function(form, fieldName) {
      return {
        'has-error': form[fieldName].$invalid && !form[fieldName].$pristine
      };
    };
    return $scope.createUser = function(event) {
      event.preventDefault();
      return UsersService.createUser($scope.newUser, function(new_user) {
        $scope.users.push(new_user);
        $scope.newUser = {};
        return $scope.userForm.$setPristine();
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
          var drawTimeline, onSelect, options, timeline;
          timeline = new links.Timeline(element.children()[0]);
          onSelect = function(e) {
            var activity;
            activity = scope.activities[timeline.getSelection()[0].row];
            return scope.selectActivity(activity);
          };
          links.events.addListener(timeline, 'select', onSelect);
          options = {
            "width": "100%",
            "height": "400px",
            "style": "box",
            "groupsOnRight": "true"
          };
          timeline.draw([], options);
          drawTimeline = function(data) {
            timeline.setData(data);
            timeline.setVisibleChartRangeAuto();
            return timeline.zoom(-.1);
          };
          return scope.$watchCollection('timelineData', function() {
            if (scope.timelineData) {
              return drawTimeline(scope.timelineData);
            }
          });
        }
      };
    }
  ]);

  angular.module('timeline').directive('datetimepicker', [
    function() {
      return {
        restrict: 'E',
        templateUrl: 'views/date-time-picker.html',
        link: function(scope, element, attrs) {
          var options;
          options = {
            format: "dd/mm/yyyy hh:ii P",
            autoclose: true,
            todayHighlight: true,
            keyboardNavigation: false
          };
          return $(element.children()[0]).datetimepicker(options);
        }
      };
    }
  ]);

  angular.module('timeline').directive('timeline', [
    function() {
      return {
        restrict: 'E',
        template: '<div></div>',
        link: function(scope, element, attrs) {
          var mapToTimeline, onChanges, onSelect, options, timeline, updateTimeline;
          onChanges = function(newValue, oldValue) {
            return updateTimeline();
          };
          scope.$watch("activities", onChanges, true);
          mapToTimeline = function(activity) {
            var start;
            start = moment(activity.date, "DD/mm/YYYY hh:mm P").toDate();
            console.log(new Date(start));
            return {
              start: start,
              content: activity.description
            };
          };
          updateTimeline = function() {
            var timelineData;
            timelineData = scope.activities.map(mapToTimeline);
            timeline.setData(timelineData);
            timeline.setVisibleChartRangeAuto();
            return timeline.zoom(-.2);
          };
          timeline = new links.Timeline(element.children()[0]);
          options = {
            "width": "100%",
            "height": "400px",
            "style": "box"
          };
          timeline.draw([], options);
          onSelect = function() {
            var selection;
            selection = timeline.getSelection();
            if (selection.length > 0) {
              scope.select(selection[0].row);
              return scope.$apply();
            }
          };
          return links.events.addListener(timeline, 'select', onSelect);
        }
      };
    }
  ]);

}).call(this);
(function() {


}).call(this);
