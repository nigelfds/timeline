describe "JourneySummaryController", ->

  scope = undefined

  beforeEach module("timeline")

  beforeEach inject (_$rootScope_) ->
    scope = _$rootScope_.$new()    

  beforeEach ->
    JourneySummaryController scope

  describe "number of handsoff and number of contact", ->

    fakeActivities1 = [
      { date: "date", description: "play with kitty", involveHandoff: true,  involveContact: false},
      { date: "date", description: "feed ferrets",    involveHandoff: false, involveContact: false},
      { date: "date", description: "sleep",           involveHandoff: true,  involveContact: false}
    ]

    fakeActivities2 = [
      { date: "date", description: "play with kitty", involveHandoff: false, involveContact: false },
      { date: "date", description: "feed ferrets",    involveHandoff: false, involveContact: true },
      { date: "date", description: "sleep",           involveHandoff: false, involveContact: true }
    ]

    it "display the total number of handoffs when there is any", ->
      scope.numberOfHandoffs(fakeActivities1).should.eql 2

    it "display the total number of contacts when there is any", ->
      scope.numberOfContacts(fakeActivities2).should.eql 2

    it "display 0 if there is no handoff", ->
      scope.numberOfHandoffs(fakeActivities2).should.eql 0

    it "display 0 if there is no contact", ->
      scope.numberOfContacts(fakeActivities1).should.eql 0

  describe "unique IT systems", ->

    fakeActivities1 = [
      { date: "date", description: "play with kitty", itSystems:  ["a", "b", "c"]},
      { date: "date", description: "feed ferrets",    itSystems:  ["c"]},
      { date: "date", description: "sleep",           itSystems:  ["b", "e"]}
    ]

    fakeActivities2 = [
      { date: "date", description: "play with kitty"},
      { date: "date", description: "feed ferrets"   },
      { date: "date", description: "sleep"          }
    ]

    describe "numberOfITSystemUpdated", ->

      it "display the total number of IT system updated across all activities when there is any", ->
        scope.numberOfITSystemUpdated(fakeActivities1).should.eql 4

      it "display 0 if no IT System get updated", ->
        scope.numberOfITSystemUpdated(fakeActivities2).should.eql 0

  describe "total number of staff involved", ->

    fakeActivities1 = [
      { date: "date", description: "play with kitty", involveHandoff: true,  involveContact: false, staffInvolved: ["a", "b", "c"]},
      { date: "date", description: "feed ferrets",    involveHandoff: false, involveContact: false, staffInvolved: ["a"]},
      { date: "date", description: "sleep",           involveHandoff: true,  involveContact: false, staffInvolved: ["c", "e"]}
    ]

    fakeActivities2 = [
      { date: "date", description: "play with kitty", involveHandoff: true,  involveContact: false},
      { date: "date", description: "feed ferrets",    involveHandoff: false, involveContact: false},
      { date: "date", description: "sleep",           involveHandoff: true,  involveContact: false}
    ]

    it "display the total number of staff involve when there is any across all activities", ->
      scope.numberOfStaffInvolved(fakeActivities1).should.eql 4

    it "display 0 if there is no staff involved", ->
      scope.numberOfStaffInvolved(fakeActivities2).should.eql 0
