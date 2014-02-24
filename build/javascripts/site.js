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
  var ActivityService;

  ActivityService = (function() {
    function ActivityService(http) {
      this.http = http;
    }

    ActivityService.prototype.getActivity = function(activityId, callback) {
      return this.http.get("/activities/" + activityId);
    };

    ActivityService.prototype.createActivity = function(data, callback) {
      var options;
      options = {
        headers: {
          'Content-Type': 'application/json'
        }
      };
      return this.http.post("/activities", data, options).success(function(new_activity) {
        return callback(new_activity);
      });
    };

    ActivityService.prototype.updateActivity = function(id, data, callback) {};

    return ActivityService;

  })();

  angular.module('timeline').factory('ActivityService', function($http) {
    return new ActivityService($http);
  });

}).call(this);
(function() {
  var EventsService;

  EventsService = (function() {
    function EventsService(http) {
      this.http = http;
    }

    EventsService.prototype.getEvents = function(userId, callback) {
      return this.http.get("/users/" + userId + "/activities").success(callback);
    };

    EventsService.prototype.createEvent = function(event, userId, callback) {
      return this.http({
        url: "/users/" + userId + "/activities",
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        data: event
      }).success(callback).error(function(data) {
        return console.log(data);
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

  ActivitiesController = function($scope, $routeParams, $timeout, ActivitiesService, UsersService) {
    var addActivity, addAlert, removeActivity, removeAlert, userId;
    userId = $routeParams.userId;
    UsersService.getUser(userId, function(user) {
      return $scope.user = user;
    });
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
    $scope.select = function(activity) {
      return $scope.selectedActivity = activity;
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
        return $scope.select(void 0);
      });
    };
    return ActivitiesService.getActivities(userId, function(activities) {
      var activity, _i, _len;
      for (_i = 0, _len = activities.length; _i < _len; _i++) {
        activity = activities[_i];
        addActivity(activity);
      }
      return $scope.select(activities[0]);
    });
  };

  angular.module('timeline').controller('ActivitiesController', ActivitiesController);

}).call(this);
(function() {
  var ActivityController;

  ActivityController = function($scope, $routeParams, ActivityService) {
    var activityId;
    activityId = $routeParams.activityId;
    return ActivityService.getActivity(activityId, function(activity) {
      return $scope.activityType = activity.activityType;
    });
  };

  angular.module('timeline').controller('ActivityController', ActivityController);

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
      return $scope.events = events.activities.map(mapEvent);
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

  UserController = function($scope, $routeParams, UsersService, $timeout, $location, ActivityService) {
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
    addAlert = function(_message) {
      var removeAlert;
      $scope.alerts.push({
        message: _message
      });
      removeAlert = function() {
        return $scope.alerts.shift();
      };
      return $timeout(removeAlert, 5000);
    };
    return $scope.createActivity = function(event, activityType) {
      var data;
      event.preventDefault();
      data = {
        userId: userId,
        activityType: activityType
      };
      return ActivityService.createActivity(data, function(newActivity) {
        return $location.path("/activities/" + newActivity._id.$oid);
      });
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

}).call(this);
(function() {
  angular.module('timeline').directive('timeline', [
    function() {
      return {
        restrict: 'E',
        template: '<div></div>',
        link: function(scope, element, attrs) {
          var mapToTimeline, onChanges, onSelect, onSelectionChange, options, timeline, updateTimeline;
          onChanges = function() {
            return updateTimeline();
          };
          scope.$watch("activities", onChanges, true);
          onSelectionChange = function(activity) {
            var index;
            index = scope.activities.indexOf(activity);
            return timeline.setSelection([
              {
                row: index
              }
            ]);
          };
          scope.$watch("selectedActivity", onSelectionChange, true);
          mapToTimeline = function(activity) {
            var start;
            start = moment(activity.date, "DD/MM/YYYY hh:mm A").toDate();
            return {
              start: start,
              content: activity.description,
              className: activity.isAPM ? "apm" : "",
              group: activity.isAPM ? "APM" : "Outside APM"
            };
          };
          updateTimeline = function() {
            var timelineData;
            timelineData = scope.activities.map(mapToTimeline);
            timeline.setData(timelineData);
            timeline.setVisibleChartRangeAuto();
            return timeline.zoom(-0.2);
          };
          timeline = new links.Timeline(element.children()[0]);
          options = {
            "width": "100%",
            "height": "400px",
            "style": "box",
            "zoomMax": 31536000000,
            "zoomMin": 86400000
          };
          timeline.draw([], options);
          onSelect = function() {
            var selectActivity, selection;
            selection = timeline.getSelection();
            if (selection.length > 0) {
              selectActivity = scope.activities[selection[0].row];
            }
            scope.select(selectActivity);
            return scope.$apply();
          };
          return links.events.addListener(timeline, 'select', onSelect);
        }
      };
    }
  ]);

}).call(this);
(function() {


}).call(this);
