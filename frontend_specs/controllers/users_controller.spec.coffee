describe "UsersController", ->

	scope = deferred = undefined

	beforeEach module("timeline")

	beforeEach inject (_$rootScope_, _$q_) ->
		scope = _$rootScope_.$new()
		deferred = _$q_.defer()

	it "should display an empty list", () ->
		usersService = sinon.createStubInstance UsersService
		usersService.getUsers.yields { "patients" : "empty" }

		usersController = UsersController scope, usersService

		scope.users.should.eql "empty"


	it "should display users", ->
		barry = name: "Barry"
		michael = name: "Michael"
		usersService = sinon.createStubInstance UsersService
		usersService.getUsers.yields {"patients":[barry, michael]}
		scope = {}

		usersController = UsersController scope, usersService


		scope.users.should.have.length 2
		scope.users[0].should.equal barry
		scope.users[1].should.equal michael

	describe 'when addining a new user', ->
		event = undefined

		beforeEach ->
			event =
				preventDefault: sinon.stub()

		it 'should create a new user with the provided name', ->
			barry = name: "Barry"
			usersService = sinon.createStubInstance UsersService
			usersService.getUsers.yields {"patients":[]}

			usersController = UsersController scope, usersService

			scope.userName = barry["name"]
			scope.createUser(event)

			usersService.createUser.should.have.been.calledWith barry

		it 'should add the new user to the scope', ->
			barry = {name: "Barry"}
			usersService = sinon.createStubInstance UsersService
			usersService.getUsers.yields {"patients":[]}
			usersService.createUser.yields barry

			usersController = UsersController scope, usersService

			scope.userName = barry["name"]
			scope.createUser(event)

			scope.users[0].should.eql barry
			#I need the "Chai things" plugin to do something like
			# scope.users.should.deep.contain barry
			#scope.users.patients.should.include.something.that.deep.equals barry

