UserDetailsController = ($scope, $timeout, UsersService) ->
  $scope.messages = new MessagesList($timeout)

  $scope.validationClass = (form, fieldName) ->
    'has-error': form[fieldName].$invalid and not form[fieldName].$pristine

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

  $scope.saveClinicalOutcomes = (user, outcomes) ->
    userId = user._id.$oid

    UsersService.updateUser userId, clinicalOutcomes: outcomes, (result) ->
      if result.success
        console.log "done!"
        angular.element('#clinicalOutcomes').modal("hide")
        onUpdateSuccess()
      else
        console.log "woot!"
        onUpdateError(result.message)

angular.module('timeline')
  .controller 'UserDetailsController', UserDetailsController
