describe "ActivitiesController", ->

    userId = '52f0329df6f4070ce200000'

    scope = routeParams = undefined

    beforeEach module("timeline")

    beforeEach inject (_$rootScope_) ->
        scope = _$rootScope_.$new()

    beforeEach ->
        routeParams = userId: userId


    describe 'when there are no activities', ->

        beforeEach ->
            activitiesService = sinon.createStubInstance ActivitiesService
            activitiesService.getActivities.withArgs(userId).yields []

            ActivitiesController scope, routeParams, activitiesService

        it "should display an empty list", ->
            scope.activities.length.should.eql 0


    describe 'when there are 2 activities', ->
        date = new Date(Date.now())

        beforeEach ->
            activity1 = date: date.toUTCString(), description: "Some activity", userId: userId
            activity2 = date: date.toUTCString(), description: "Another activity", userId: userId
            activitiesService = sinon.createStubInstance ActivitiesService
            activitiesService.getActivities.yields [activity1, activity2]

            ActivitiesController scope, routeParams, activitiesService

        it "should display activities", ->
            scope.activities[0].content.should.eql "Some activity"
            expect(scope.activities[0].start).to.equalDate date

            scope.activities[1].content.should.eql "Another activity"
            expect(scope.activities[1].start).to.equalDate date

    describe 'when adding a new activity' , ->
        activity = undefined
        date = new Date(2013,2,12,0,0,0)
        time = new Date(2013,0,0,10,15,0)
        activitiesService = undefined

        beforeEach ->
            activity   = {description: "Some activity", start: date.toUTCString()}
            activitiesService = sinon.createStubInstance ActivitiesService
            activitiesService.getActivities.withArgs(userId).yields []
            activitiesService.createActivity.yields {description: "Some activity"}

        it 'should create a new activity with valid data', ->
            ActivitiesController scope, routeParams, activitiesService

            scope.date = date
            scope.time = date
            scope.description = "Some activity"

            scope.createActivity()

            values = date: date.toString(), description: "Some activity"
            activitiesService.createActivity.should.have.been.calledWith userId, values

        it 'should produce a request with combined date and time', ->
            ActivitiesController scope, routeParams, activitiesService

            scope.date = date
            scope.time = time
            scope.description = "Some activity"

            scope.createActivity()

            values = date: new Date(2013,2,12,10,15,0).toString(), description: "Some activity"
            activitiesService.createActivity.should.have.been.calledWith userId, values
                

        it 'should append new activity to the scope', ->
            ActivitiesController scope, routeParams, activitiesService

            scope.date = date
            scope.time = time
            scope.description = "Some activity"

            scope.createActivity()

            scope.activities.length.should.be.eql 1

        it 'should initialise the time and date variables', ->
            ActivitiesController scope, routeParams, activitiesService

            expect(scope.date).to.exist
            expect(scope.time).to.exist

