describe "UsersController", ->

	scope = deferred = undefined

	beforeEach module("timeline")

	beforeEach inject (_$rootScope_, _$q_) ->
		scope = _$rootScope_.$new()
		deferred = _$q_.defer()

	it "should display an empty list", () ->
		usersService = sinon.createStubInstance UsersService
		usersService.getUsers.yields "empty"

		usersController = UsersController scope, usersService

		scope.users.should.eql "empty"


	it "should display users", ->
		barry = name: "Barry"
		michael = name: "Michael"
		usersService = sinon.createStubInstance UsersService
		usersService.getUsers.yields {"patients":[barry, michael]}
		scope = {}

		usersController = UsersController scope, usersService

		scope.users.patients.should.contain barry
		scope.users.patients.should.contain michael
