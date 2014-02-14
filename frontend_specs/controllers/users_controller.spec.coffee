describe "UsersController", ->

	scope = deferred = undefined

	beforeEach module("timeline")

	beforeEach inject (_$rootScope_, _$q_) ->
		scope = _$rootScope_.$new()
		deferred = _$q_.defer()

	it "should display an empty list", () ->
		usersService = sinon.createStubInstance UsersService
		usersService.getUsers.yields []

		usersController = UsersController scope, usersService

		scope.users.should.eql []


	it "should display users", ->
		barry = name: "Barry"
		michael = name: "Michael"
		usersService = sinon.createStubInstance UsersService
		usersService.getUsers.yields [ barry, michael ]
		scope = {}

		usersController = UsersController scope, usersService


		scope.users.should.have.length 2
		scope.users[0].should.equal barry
		scope.users[1].should.equal michael

	describe 'when addining a new user', ->
		event = barry = undefined

		beforeEach ->
			event =
				preventDefault: sinon.stub()
			barry = {
						name: "Barry",
						urNumber: "1234567890",
						age:"35",
						gender:"male"
					}

		it 'should create a new user with the provided name', ->
			usersService = sinon.createStubInstance UsersService
			usersService.getUsers.yields []

			usersController = UsersController scope, usersService

			scope.userName = barry["name"]
			scope.age = barry["age"]
			scope.urNumber = barry["urNumber"]
			scope.gender = barry["gender"]
			scope.createUser(event)

			usersService.createUser.should.have.been.calledWith barry

		it 'should add the new user to the scope', ->

			usersService = sinon.createStubInstance UsersService
			usersService.getUsers.yields []
			usersService.createUser.yields barry

			usersController = UsersController scope, usersService

			scope.userName = barry["name"]
			scope.age = barry["age"]
			scope.urNumber = barry["urNumber"]
			scope.gender = barry["gender"]
			scope.createUser(event)

			scope.users.should.contain.members [barry]

		it 'should remove all the variables from the scope', ->
			usersService = sinon.createStubInstance UsersService
			usersService.getUsers.yields []
			usersService.createUser.yields barry

			usersController = UsersController scope, usersService

			scope.userName = barry["name"]
			scope.age = barry["age"]
			scope.urNumber = barry["urNumber"]
			scope.gender = barry["gender"]
			scope.createUser(event)

			expect(scope.userName).to.be.undefined
			expect(scope.urNumber).to.be.undefined
			expect(scope.age).to.be.undefined
			expect(scope.gender).to.be.undefined

