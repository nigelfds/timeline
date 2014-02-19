describe "Basis32Controller", ->

  scope = routeParams = service = undefined

  beforeEach ->
    scope = {}
    routeParams =
      userId: "something"
      activityId: "id of the activity"

    service = sinon.createStubInstance ActivityService
    Basis32Controller scope, routeParams, service


  it "provides all the questions on the form", ->

    scope.questions.length.should.eql 15

    scope.questions[0].should.eql text: "Managing day to day life (e.g. Getting to places on time, handling money, making everyday decisions)"
    scope.questions[1].should.eql text: "Household responsibilities (e.g. Shopping, cooking, laundry, keeping room clean, other chores)"
    scope.questions[2].should.eql text: "Work (e.g. Completing tasks, performance level, finding / keeping a job)"
    scope.questions[3].should.eql text: "School (e.g. academic performance, completing assignments, attendance)"
    scope.questions[4].should.eql text: "Leisure time or recreational activities"
    scope.questions[5].should.eql text: "Adjusting to major life stresses (e.g. separation, divorce, moving, new job, new school, a death)"
    scope.questions[6].should.eql text: "Relationships with family members"
    scope.questions[7].should.eql text: "Getting along with people outside of the family"
    scope.questions[8].should.eql text: "Isolation or feelings of loneliness"
    scope.questions[9].should.eql text: "Being able to feel close to others"
    scope.questions[10].should.eql text: "Being realistic about yourself to others"
    scope.questions[11].should.eql text: "Recognising and expressing emotions appropriately"
    scope.questions[12].should.eql text: "Developing indepencence, autonomy"
    scope.questions[13].should.eql text: "Goals or direction of life"
    scope.questions[14].should.eql text: "Lack of self-confidence, feeling bad about yourself"

  describe "answers", ->

    it "saves the answer to the question", ->

      data =
        index: 4
        answer: 3

      scope.answer(data.index, data.answer)

      service.updateActivity.should.have.been.calledWith routeParams.activityId, data

