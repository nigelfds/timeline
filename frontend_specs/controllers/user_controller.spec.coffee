describe "User controller", ->

	scope = routeParams = service = undefined

	test_user = 
		"_id": "some_user_id"
		"name": "Seaton"
		"numberOfHandovers": 45

	beforeEach ->
		scope = {}
		routeParams = userId: test_user.id
		service = sinon.createStubInstance UsersService
		service.getUser.withArgs(test_user.id).yields test_user

		UserController scope, routeParams, service

	it "should display the user", ->
		scope.user.should.be.eql test_user

	describe "save", ->
		beforeEach ->
			scope.user = test_user
			scope.userForm = $invalid: false

		it "should save the updated information", ->
			scope.save()

			data = 
				"name" : test_user.name
				"numberOfHandovers" : test_user.numberOfHandovers

			service.updateUser.should.have.been.calledWith test_user.id, data

		describe "when the form is not valid", ->
			beforeEach -> scope.userForm = $invalid: true
			
			it "should not send anything to the service", ->
				scope.save()

				service.updateUser.should.not.have.been.called

