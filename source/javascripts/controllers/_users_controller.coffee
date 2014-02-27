UsersController = ($scope, $timeout, UsersService) ->
  $scope.messages = new MessagesList($timeout)

  UsersService.getUsers (users) ->
    $scope.users = users

  $scope.validationClass = (form, fieldName) ->
    'has-error': form[fieldName].$invalid and not form[fieldName].$pristine

  onCreateUserSuccess = (user) ->
    $scope.users.push user
    $scope.newUser = {}
    $scope.newUserForm.$setPristine()
    $scope.messages.add "User created successfully", "success"

  onCreateUserError = (message) ->
    $scope.messages.add message, "danger"

  $scope.createUser = ->
    UsersService.createUser $scope.newUser, (result) ->
      if result.success
      then onCreateUserSuccess(result.user) 
      else onCreateUserError(result.message)

  $scope.onSubmit = (viewValue) ->
    console.log viewValue

angular.module('timeline').controller 'UsersController', UsersController
