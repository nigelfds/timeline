SelectedActivityController = ($scope) ->

  $scope.selectAllOnClick = (_event) -> _event.target.select()




angular.module('timeline')
  .controller 'SelectedActivityController', SelectedActivityController
