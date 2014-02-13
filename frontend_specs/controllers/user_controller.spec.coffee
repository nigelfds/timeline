describe "User controller", ->

	scope = routeParams = service = undefined

	test_user = 
		"_id": "some_user_id"
		"name": "Seaton"
		"numberOfHandovers": 45
		"numberOfPeopleInvolved": 10
		"numberOfContacts": 34

	beforeEach ->
		scope = {}
		routeParams = userId: test_user.id
		service = sinon.createStubInstance UsersService
		service.getUser.withArgs(test_user.id).yields test_user

		UserController scope, routeParams, service

	it "displays the user", ->
		scope.user.should.be.eql test_user

	describe "save", ->
		beforeEach ->
			scope.user = test_user
			scope.userForm = 
				numberOfHandovers: $valid : true
				numberOfPeopleInvolved: $valid : true
				numberOfContacts: $valid : true

		it "saves only the specified property", ->
			scope.save "numberOfPeopleInvolved"

			data = "numberOfPeopleInvolved": test_user.numberOfPeopleInvolved

			service.updateUser.should.have.been.calledWith test_user.id, data


		describe "when data is invalid", ->
			beforeEach -> scope.userForm.numberOfHandovers.$valid = false
			
			it "doesn't save the property", ->
				scope.save "numberOfHandovers"

				service.updateUser.should.not.have.been.called



