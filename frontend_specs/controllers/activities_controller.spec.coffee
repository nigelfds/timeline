describe "ActivitiesController", ->

    userId = '52f0329df6f4070ce200000'
    now = new Date("1/1/2014 13:00")
    activityId = '51a0329df6f4070ce200000'
    scope = routeParams = activitiesService = activities = undefined

    beforeEach module("timeline")

    beforeEach inject (_$rootScope_) ->
        scope = _$rootScope_.$new()

    beforeEach ->
        routeParams = userId: userId
        activity1 = date: now.toUTCString(), description: "Activity 1", userId: userId
        activity2 = date: now.toUTCString(), description: "Activity 2", userId: userId
        activities = [activity1, activity2]
        activitiesService = sinon.createStubInstance ActivitiesService
        activitiesService.getActivities.withArgs(userId).yields activities

    it "displays the correct activities on the timeline", ->
        ActivitiesController scope, routeParams, activitiesService

        scope.timelineData[0].start.toUTCString().should.eql activities[0].date
        scope.timelineData[0].content.should.eql activities[0].description

        scope.timelineData[1].start.toUTCString().should.eql activities[1].date
        scope.timelineData[1].content.should.eql activities[1].description

    describe "when adding a new activity", ->

        it "creates a new activity with defaults", ->
            Date.now = sinon.stub()
            Date.now.returns now.getTime()
            values = date: now.toString(), description: "New Activity"
            newActivity = date: now.toUTCString(), description: "Some activity"
            activitiesService.createActivity.withArgs(userId, values).yields newActivity
            
            ActivitiesController scope, routeParams, activitiesService

            scope.newActivity()

            scope.currentActivity.should.eql newActivity

            scope.timelineData[2].start.toUTCString().should.eql newActivity.date
            scope.timelineData[2].content.should.eql newActivity.description

    describe "saving the current activity", ->
        activityId = values = currentActivity = undefined

        beforeEach ->
            activityId = '51a0329df6f4070ce200000'
            values = date: now.toUTCString(), description: "Some activity"
            currentActivity =
                "_id": "$oid": activityId
                date: values.date
                description: values.description
            activitiesService.updateActivity.withArgs(userId, activityId, values).yields true

            ActivitiesController scope, routeParams, activitiesService

            scope.currentActivity = currentActivity
            scope.saveActivity()


        it "saves the current activity", ->
            activitiesService.updateActivity.should.have.been.calledWith userId, activityId, values

    xdescribe 'when adding a new activity' , ->
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

