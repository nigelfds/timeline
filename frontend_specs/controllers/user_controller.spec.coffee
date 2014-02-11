describe "User controller", ->

	scope = routeParams = service = undefined

	test_user = 
		id: "some_user_id"
		name: "Seaton"

	beforeEach ->
		scope = {}
		routeParams = userId: test_user.id
		service = sinon.createStubInstance UsersService
		service.getUser.withArgs(test_user.id).yields name: test_user.name

	it "should display the users name", ->

		controller = UserController scope, routeParams, service

		scope.name.should.be.eql "Seaton"