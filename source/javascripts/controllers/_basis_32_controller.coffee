Basis32Controller = ($scope, $routeParams) ->

  $scope.questions = [
    { text: "Managing day to day life (e.g. Getting to places on time, handling money, making everyday decisions)" }
    { text: "Household responsibilities (e.g. Shopping, cooking, laundry, keeping room clean, other chores)"                   }
    { text: "Work (e.g. Completing tasks, performance level, finding / keeping a job)" }
    { text: "School (e.g. academic performance, completing assignments, attendance)"               }
    { text: "Leisure time or recreational activities" }
    { text: "Adjusting to major life stresses (e.g. separation, divorce, moving, new job, new school, a death)" }
    { text: "Relationships with family members" }
    { text: "Getting along with people outside of the family" }
    { text: "Isolation or feelings of loneliness" }
    { text: "Being able to feel close to others" }
    { text: "Being realistic about yourself to others" }
    { text: "Recognising and expressing emotions appropriately" }
    { text: "Developing indepencence, autonomy" }
    { text: "Goals or direction of life" }
    { text: "Lack of self-confidence, feeling bad about yourself" }
  ]

# angular.module('timeline')
#     .controller 'Basis32Controller', Basis32Controller
