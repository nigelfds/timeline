angular.module('timeline')
  .directive('datetimepicker', [ ->
    restrict: 'E',
    templateUrl: 'views/date-time-picker.html'
    scope: 
      model: "="
      minView: "="
      format: "="
    link: (scope, element, attrs) ->

      format = attrs.format or "dd/mm/yyyy hh:ii P"
      minView = attrs.minview or "hour"

      options =
        format: format
        autoclose: true
        todayHighlight: true
        todayBtn: true
        keyboardNavigation: false
        minuteStep: 1
        forceParse: false
        minView: minView
        viewSelect: "month"
      $(element.children()[0]).datetimepicker options

      $(element.children()[0]).datetimepicker().on "show",(x) ->
        $(element.children()[0]).datetimepicker("setEndDate", moment().toDate())

  ]
) 
