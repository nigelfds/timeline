UserDetailsController = ($scope, $timeout, UsersService) ->
  $scope.messages = new MessagesList($timeout)

  onUpdateSuccess = -> 
    $scope.messages.add "Updated successfully", "success" 

  onUpdateError = (message) ->
    $scope.messages.add message, "danger"

  $scope.save = (user) ->
    userId = user._id.$oid
    values = {}
    values[property] = value for property, value of user when property isnt "_id"
    UsersService.updateUser userId, values, (result) ->
      if result.success
      then onUpdateSuccess()
      else onUpdateError(result.message)

angular.module('timeline')
  .controller 'UserDetailsController', UserDetailsController
