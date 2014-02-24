angular.module('timeline')
  .directive('datetimepicker', [ ->
    restrict: 'E',
    templateUrl: 'views/date-time-picker.html'
    link: (scope, element, attrs) ->

      options =
        format: "dd/mm/yyyy hh:ii P"
        autoclose: true
        todayHighlight: true
        keyboardNavigation: false
      $(element.children()[0]).datetimepicker options
  ]
) 
