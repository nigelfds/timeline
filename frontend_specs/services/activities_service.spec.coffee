describe 'ActivitiesService', () ->

  userId = '52f0329df6f4070ce200000'
  ActivitiesService = $httpBackend = undefined

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

  describe 'when creating a new activity' , ->

    it 'returns the activity', ->
      new_activity = description: "Some content"
      values = angular.toJson description: "Some content", date: "yesterday"

      $httpBackend.whenPOST("/users/#{userId}/activities", values).respond new_activity

      ActivitiesService.createActivity userId, values, (activity) ->
        activity.should.eql new_activity

      $httpBackend.flush()

  describe 'when updating an activity', ->

    it 'saves the activity', ->
      activityId = "an-activity-id"
      values = angular.toJson date: new Date(), description: "Some content"

      $httpBackend.whenPUT("/users/#{userId}/activities/#{activityId}", values).respond {}

      ActivitiesService.updateActivity userId, activityId, values, (success) ->
        success.should.be.true

      $httpBackend.flush()

  describe "deleting an activity", ->

    it "deletes the activity", ->
      activityId = "an-activity-id"

      $httpBackend.whenDELETE("/users/#{userId}/activities/#{activityId}").respond {}

      ActivitiesService.deleteActivity userId, activityId, (success) ->
        success.should.be.true

      $httpBackend.flush()
