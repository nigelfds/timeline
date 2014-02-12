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

		it "should save the updated information", ->
			scope.user = test_user
			scope.user.numberOfHandovers = 99

			scope.save()

			data = {}
			data[property] = value for property, value of test_user when property != "_id"

			service.updateUser.should.have.been.calledWith test_user.id, data
