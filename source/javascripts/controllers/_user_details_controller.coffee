UserDetailsController = ($scope, $timeout, UsersService) ->
  $scope.messages = []

  $scope.save = (user) ->
    userId = user._id.$oid
    values = {}
    values[property] = value for property, value of user when property isnt "_id"
    UsersService.updateUser userId, values, (success) ->
      addMessage "Updated successfully", "success" if success
      addMessage "Update failed", "danger" unless success


  addMessage = (text, type) ->
    $scope.messages.push text: text, type: type
    $timeout(removeAlert, 5000)

  removeAlert = ->
    $scope.messages.shift()

angular.module('timeline')
  .controller 'UserDetailsController', UserDetailsController
