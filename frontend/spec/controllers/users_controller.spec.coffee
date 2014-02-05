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


		scope.users.patients.should.have.length 2
		scope.users.patients[0].should.equal barry
		scope.users.patients[1].should.equal michael

	describe 'when addining a new user', ->
		it 'should create a new user with the provided name', ->
			barry = name: "Barry"
			usersService = sinon.createStubInstance UsersService
			usersService.getUsers.yields {"patients":[]}

			usersController = UsersController scope, usersService

			scope.userName = barry["name"]
			scope.createUser()

			usersService.createUser.should.have.been.calledWith barry

		it 'should add the new user to the scope', ->
			barry = {name: "Barry"}
			usersService = sinon.createStubInstance UsersService
			usersService.getUsers.yields {"patients":[]}
			usersService.createUser.yields barry

			usersController = UsersController scope, usersService

			scope.userName = barry["name"]
			scope.createUser()

			scope.users.patients[0].should.eql barry
			#I need the "Chai things" plugin to do something like
			#scope.users.patients.should.include.something.that.deep.equals barry

