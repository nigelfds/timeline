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

  describe "IT systems", ->

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

    describe "count of IT systems", ->
      it "returns the correct count", ->
        scope.countOfITSystemUpdates(fakeActivities1).should.eql 6

    describe "numberOfITSystemUpdated", ->

      it "display the total number of IT system updated across all activities when there is any", ->
        scope.numberOfITSystemUpdated(fakeActivities1).should.eql 4

      it "display 0 if no IT System get updated", ->
        scope.numberOfITSystemUpdated(fakeActivities2).should.eql 0

  describe "total number of staff involved", ->

    fakeActivities1 = [
      { date: "date", description: "play with kitty", staffInvolved: ["a", "b", "c"]},
      { date: "date", description: "feed ferrets",    staffInvolved: ["a"]},
      { date: "date", description: "sleep",           staffInvolved: ["c", "e"]}
    ]

    fakeActivities2 = [
      { date: "date", description: "play with kitty"},
      { date: "date", description: "feed ferrets"   },
      { date: "date", description: "sleep"          }
    ]

    it "display the total number of staff involve when there is any across all activities", ->
      scope.numberOfStaffInvolved(fakeActivities1).should.eql 4

    it "display 0 if there is no staff involved", ->
      scope.numberOfStaffInvolved(fakeActivities2).should.eql 0


  describe "Paper record updated", ->

    fakeActivities1 = [
      { date: "date", description: "play with kitty", paperRecords: ["a", "b", "c"]},
      { date: "date", description: "feed ferrets",    paperRecords: ["a"]},
      { date: "date", description: "sleep",           paperRecords: ["c", "e"]}
    ]

    fakeActivities2 = [
      { date: "date", description: "play with kitty"},
      { date: "date", description: "feed ferrets"   },
      { date: "date", description: "sleep"          }
    ]

    describe "count of paper record updates", ->

      it "returns the correct count", ->
        scope.countOfPaperRecordUpdates(fakeActivities1).should.eql 6

      it "returns zero if there are none", ->
        scope.countOfPaperRecordUpdates(fakeActivities2).should.eql 0

    describe "unique paper records", ->

      it "display the total number of paper records", ->
        scope.numberOfPaperRecordUpdated(fakeActivities1).should.eql 4

      it "display 0 if no paper records get updated", ->
        scope.numberOfPaperRecordUpdated(fakeActivities2).should.eql 0


  describe "therapeutic contributions", ->
    activities = [
      { date: "date", description: "play with kitty" },
      { date: "date", description: "feed ferrets" },
      { date: "date", description: "sleep" }
    ]

    it "returns zero if there are none", ->
      result = scope.numberOfTherapeuticContributions(activities)

      result.should.be.eql 0

    it "returns the correct count", ->
      activities[0].isAPM = true
      activities[0].contributesTherapeutically = true
      activities[1].isAPM = true
      activities[1].contributesTherapeutically = false
      activities[2].isAPM = false
      activities[2].contributesTherapeutically = true

      result = scope.numberOfTherapeuticContributions(activities)

      result.should.be.eql 1

  describe "APM activities", ->

    activities = [
      { date: "date", description: "play with kitty" },
      { date: "date", description: "feed ferrets" },
      { date: "date", description: "sleep" }
    ]

    it "returns zero if there are none", ->
      result = scope.numberOfAPMActivities(activities)

      result.should.be.eql 0

    it "returns the correct count", ->
      activities[0].isAPM = true
      activities[1].isAPM = true
      activities[2].isAPM = false

      result = scope.numberOfAPMActivities(activities)

      result.should.be.eql 2
