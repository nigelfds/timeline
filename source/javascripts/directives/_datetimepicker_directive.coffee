angular.module('timeline')
  .directive('datetimepicker', [ ->
    restrict: 'E',
    templateUrl: 'views/date-time-picker.html'
    link: (scope, element, attrs) ->

      options =
        format: "dd/mm/yyyy hh:ii P"
        autoclose: true
        todayHighlight: true
        todayBtn: true
        keyboardNavigation: false
        minuteStep: 1
      $(element.children()[0]).datetimepicker options
  ]
) 
