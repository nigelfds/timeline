describe "User controller", ->

	scope = routeParams = service = timeout = undefined

	test_user =
		"_id": "some_user_id"
		"name": "Seaton"
		"urNumber": 123456789
		"age": 30
		"gender": "male"
		"numberOfHandovers": 45
		"numberOfPeopleInvolved": 10
		"numberOfContacts": 34

	beforeEach ->
		scope = {}
		routeParams = userId: test_user.id
		service = sinon.createStubInstance UsersService
		service.getUser.withArgs(test_user.id).yields test_user

		timeout = sinon.stub()

		UserController scope, routeParams, service, timeout

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
			scope.save scope.userForm, "numberOfPeopleInvolved"

			data = "numberOfPeopleInvolved": test_user.numberOfPeopleInvolved

			service.updateUser.should.have.been.calledWith test_user.id, data

		it "alerts on success", ->
			data = "numberOfPeopleInvolved": test_user.numberOfPeopleInvolved
			service.updateUser.withArgs(test_user.id, data).yields true

			scope.save scope.userForm, "numberOfPeopleInvolved"

			scope.alerts[0].message.should.eql "Updated user successfully"

		describe "when data is invalid", ->
			beforeEach -> scope.userForm.numberOfHandovers.$valid = false

			it "doesn't save the property", ->
				scope.save scope.userForm, "numberOfHandovers"

				service.updateUser.should.not.have.been.called



