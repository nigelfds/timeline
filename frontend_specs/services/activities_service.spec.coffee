describe 'ActivitiesService', () ->

    ActivitiesService = undefined
    $httpBackend = undefined
    userId = '52f0329df6f4070ce200000'

    beforeEach module 'timeline'

    beforeEach inject (_ActivitiesService_, _$httpBackend_) ->
        ActivitiesService = _ActivitiesService_
        $httpBackend = _$httpBackend_

    describe 'when retrieving a list of activities', ->
        it 'returns the correct activities', ->
            $httpBackend.whenGET("/users/#{userId}/activities").respond ["activity1", "activity2"]

            ActivitiesService.getActivities userId, (activities) ->
                activities.should.eql ["activity1", "activity2"]

            $httpBackend.flush()

    describe 'when creating a new event' , ->
        it 'should make a post to the event api', ()->
            values = angular.toJson {description: "Some content", start: Date.now()}

            $httpBackend.whenPOST("/users/#{userId}/activities", values).respond {description: "Some content"}

            ActivitiesService.createActivity userId, values, (activity) ->
                activity.should.eql {description: "Some content"}

            $httpBackend.flush()