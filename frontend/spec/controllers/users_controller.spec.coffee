describe "UsersController", ->

	scope = undefined

	beforeEach module("timeline")

	beforeEach inject (_$rootScope_) -> scope = _$rootScope_.$new()

	it "should display an empty list", (done) ->
		usersService = sinon.createStubInstance UsersService
		usersService.getUsers.yieldsAsync {}

		scope.$watch "users", (newValue, oldValue) -> 
			newValue.should.eql {}
			done()

		scope.users = {}
		# usersController = UsersController scope, usersService

		scope.$apply()



	xit "should display users", ->
		barry = name: "Barry"
		michael = name: "Michael"
		usersService = sinon.createStubInstance UsersService
		usersService.getUsers.yields {"patients":[barry, michael]}
		scope = {}

		usersController = UsersController scope, usersService

		scope.users.patients.should.contain barry
		scope.users.patients.should.contain michael
