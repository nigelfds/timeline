describe "User controller", ->

	scope = routeParams = service = undefined

	test_user = 
		id: "some_user_id"
		name: "Seaton"
		numberOfHandovers: 45

	beforeEach ->
		scope = {}
		routeParams = userId: test_user.id
		service = sinon.createStubInstance UsersService
		service.getUser.withArgs(test_user.id).yields test_user

	it "should display the user", ->

		UserController scope, routeParams, service

		scope.user.should.be.eql test_user

	describe "save", ->

		it "should add a save function to the scope", ->

			UserController scope, routeParams, service

			scope.save.should.be.a("function")

		it "should save the updated information", ->
			UserController scope, routeParams, service

			scope.user = test_user
			scope.user.numberOfHandovers = 99

			scope.save()

			data = numberOfHandovers: scope.user.numberOfHandovers

			service.updateUser.should.have.been.calledWith test_user.id, data