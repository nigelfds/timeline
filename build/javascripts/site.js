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

  ActivitiesController = function($scope, $routeParams, $timeout, ActivitiesService, UsersService) {
    var addActivity, addAlert, removeActivity, uniqueAcrossActivities, userId;
    userId = $routeParams.userId;
    UsersService.getUser(userId, function(user) {
      return $scope.user = user;
    });
    $scope.alerts = new MessagesList($timeout);
    addAlert = function(text, type) {
      return $scope.alerts.add(text, type);
    };
    $scope.activities = [];
    $scope.selectAllOnClick = function(_event) {
      return _event.target.select();
    };
    uniqueAcrossActivities = function(name, activities) {
      var activity, element, unique, _i, _j, _len, _len1, _ref;
      unique = [];
      for (_i = 0, _len = activities.length; _i < _len; _i++) {
        activity = activities[_i];
        if (activity[name] != null) {
          _ref = activity[name];
          for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
            element = _ref[_j];
            if (unique.indexOf(element) === -1) {
              unique.push(element);
            }
          }
        }
      }
      return unique;
    };
    $scope.addNewStaffInvolved = function() {
      if ($scope.selectedActivity.staffInvolved === void 0) {
        $scope.selectedActivity.staffInvolved = [];
      }
      if ($scope.selectedActivity.staffInvolved.indexOf($scope.newStaffName) === -1) {
        $scope.selectedActivity.staffInvolved.push($scope.newStaffName);
        return $scope.save();
      } else {
        return addAlert("Existing Staff Member Name!", "danger");
      }
    };
    $scope.removeStaffInvolved = function(staffName) {
      var index;
      index = $scope.selectedActivity.staffInvolved.indexOf(staffName);
      $scope.selectedActivity.staffInvolved.splice(index, 1);
      return $scope.save();
    };
    $scope.staffInvolved = function(activities) {
      return uniqueAcrossActivities("staffInvolved", activities);
    };
    $scope.addNewITSystem = function() {
      if ($scope.selectedActivity.itSystems === void 0) {
        $scope.selectedActivity.itSystems = [];
      }
      if ($scope.selectedActivity.itSystems.indexOf($scope.newITSystemName) === -1) {
        $scope.selectedActivity.itSystems.push($scope.newITSystemName);
        return $scope.save();
      } else {
        return addAlert("Duplicated IT System name", "danger");
      }
    };
    $scope.removeITSystem = function(systemName) {
      var index;
      index = $scope.selectedActivity.itSystems.indexOf(systemName);
      $scope.selectedActivity.itSystems.splice(index, 1);
      return $scope.save();
    };
    $scope.itSystemsUpdated = function(activities) {
      return uniqueAcrossActivities("itSystems", activities);
    };
    $scope.addNewPaperRecord = function() {
      if ($scope.selectedActivity.paperRecords === void 0) {
        $scope.selectedActivity.paperRecords = [];
      }
      if ($scope.selectedActivity.paperRecords.indexOf($scope.newPaperRecord) === -1) {
        $scope.selectedActivity.paperRecords.push($scope.newPaperRecord);
        return $scope.save();
      } else {
        return addAlert("Duplicated Paper Record name", "danger");
      }
    };
    $scope.removePaperRecord = function(paperRecordName) {
      var index;
      index = $scope.selectedActivity.paperRecords.indexOf(paperRecordName);
      $scope.selectedActivity.paperRecords.splice(index, 1);
      return $scope.save();
    };
    $scope.paperRecordslist = function(activities) {
      return uniqueAcrossActivities("paperRecords", activities);
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
      var defaultDate, defaults, length;
      length = $scope.activities.length;
      defaultDate = moment(new Date(Date.now())).format("DD/MM/YYYY hh:mm A");
      if (length > 0) {
        defaultDate = $scope.activities[length - 1].date;
      }
      defaults = {
        date: defaultDate,
        description: "New Activity"
      };
      return ActivitiesService.createActivity(userId, defaults, function(new_activity) {
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
        addAlert("Updated successfully", "success");
        $scope.newStaffName = "";
        $scope.newITSystemName = "";
        return $scope.newPaperRecord = "";
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
  var JourneySummaryController;

  JourneySummaryController = function($scope) {
    var numOccurrenceOf, uniqueAcrossActivities;
    uniqueAcrossActivities = function(name, activities) {
      var activity, element, unique, _i, _j, _len, _len1, _ref;
      unique = [];
      for (_i = 0, _len = activities.length; _i < _len; _i++) {
        activity = activities[_i];
        if (activity[name] != null) {
          _ref = activity[name];
          for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
            element = _ref[_j];
            if (unique.indexOf(element) === -1) {
              unique.push(element);
            }
          }
        }
      }
      return unique;
    };
    $scope.numberOfStaffInvolved = function(activities) {
      return uniqueAcrossActivities("staffInvolved", activities).length;
    };
    $scope.numberOfITSystemUpdated = function(activities) {
      return uniqueAcrossActivities("itSystems", activities).length;
    };
    $scope.countOfITSystemUpdates = function(activities) {
      var activity, sum, _i, _len;
      sum = 0;
      for (_i = 0, _len = activities.length; _i < _len; _i++) {
        activity = activities[_i];
        if (activity.itSystems) {
          sum += activity.itSystems.length;
        }
      }
      return sum;
    };
    $scope.numberOfPaperRecordUpdated = function(activities) {
      return uniqueAcrossActivities("paperRecords", activities).length;
    };
    $scope.countOfPaperRecordUpdates = function(activities) {
      var activity, sum, _i, _len;
      sum = 0;
      for (_i = 0, _len = activities.length; _i < _len; _i++) {
        activity = activities[_i];
        if (activity.paperRecords) {
          sum += activity.paperRecords.length;
        }
      }
      return sum;
    };
    numOccurrenceOf = function(name, activities) {
      var activity, occurrence, _i, _len;
      occurrence = 0;
      for (_i = 0, _len = activities.length; _i < _len; _i++) {
        activity = activities[_i];
        if (activity[name]) {
          occurrence += 1;
        }
      }
      return occurrence;
    };
    $scope.numberOfHandoffs = function(activities) {
      return numOccurrenceOf("involveHandoff", activities);
    };
    $scope.numberOfContacts = function(activities) {
      return numOccurrenceOf("involveContact", activities);
    };
    $scope.numberOfTherapeuticContributions = function(activities) {
      var activity, sum, _i, _len;
      sum = 0;
      for (_i = 0, _len = activities.length; _i < _len; _i++) {
        activity = activities[_i];
        if (activity.isAPM && activity.contributesTherapeutically) {
          sum++;
        }
      }
      return sum;
    };
    return $scope.numberOfAPMActivities = function(activities) {
      return numOccurrenceOf("isAPM", activities);
    };
  };

  angular.module('timeline').controller('JourneySummaryController', JourneySummaryController);

}).call(this);
(function() {
  var MessagesList,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  MessagesList = (function(_super) {
    __extends(MessagesList, _super);

    function MessagesList(timeout) {
      this.timeout = timeout;
      MessagesList.__super__.constructor.call(this);
    }

    MessagesList.prototype.add = function(text, type) {
      var _this = this;
      this.push({
        text: text,
        type: type
      });
      return this.timeout((function() {
        return _this.shift();
      }), 5000);
    };

    return MessagesList;

  })(Array);

  window.MessagesList = MessagesList;

}).call(this);
(function() {
  var UserDetailsController;

  UserDetailsController = function($scope, $timeout, UsersService) {
    $scope.messages = new MessagesList($timeout);
    return $scope.save = function(user) {
      var property, userId, value, values;
      userId = user._id.$oid;
      values = {};
      for (property in user) {
        value = user[property];
        if (property !== "_id") {
          values[property] = value;
        }
      }
      return UsersService.updateUser(userId, values, function(success) {
        if (success) {
          $scope.messages.add("Updated successfully", "success");
        }
        if (!success) {
          return $scope.messages.add("Update failed", "danger");
        }
      });
    };
  };

  angular.module('timeline').controller('UserDetailsController', UserDetailsController);

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
            return timeline.setData(timelineData);
          };
          timeline = new links.Timeline(element.children()[0]);
          options = {
            width: "100%",
            minHeight: 400,
            style: "box",
            zoomMax: 31536000000,
            zoomMin: 86400000,
            customStackOrder: function(item1, item2) {
              return item1.start - item2.start;
            }
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
