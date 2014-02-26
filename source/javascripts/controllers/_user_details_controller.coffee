UserDetailsController = ($scope, $timeout, UsersService) ->
  $scope.messages = new MessagesList($timeout)

  $scope.save = (user) ->
    userId = user._id.$oid
    values = {}
    values[property] = value for property, value of user when property isnt "_id"
    UsersService.updateUser userId, values, (success) ->
      $scope.messages.add "Updated successfully", "success" if success
      $scope.messages.add "Update failed", "danger" unless success

angular.module('timeline')
  .controller 'UserDetailsController', UserDetailsController
