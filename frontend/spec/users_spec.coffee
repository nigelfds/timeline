describe "UserController", ->

	it "should display an empty list", ->
		usersService = sinon.createStubInstance UsersService
		usersService.getUsers.yields []
		_scope = {}

		usersController = UserController _scope, usersService

		_scope.users.length.should.eql 0


	it "should display users", ->
		barry = name: "Barry"
		michael = name: "Michael"
		usersService = sinon.createStubInstance UsersService
		usersService.getUsers.yields {"patients":[barry, michael]}
		_scope = {}

		usersController = UserController _scope, usersService

		_scope.users.patients.should.contain barry
		_scope.users.patients.should.contain michael