angular.module('timeline')
  .directive('datetimepicker', [ ->
    restrict: 'E',
    templateUrl: 'views/date-time-picker.html'
    replace: true
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
      $(element).datetimepicker options

      $(element).datetimepicker().on "show",(x) ->
        $(element).datetimepicker("setEndDate", moment().toDate())

  ]
) 
