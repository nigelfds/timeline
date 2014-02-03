describe "UsersController", ->

	scope = service = undefined

	beforeEach ->
		scope = {}
		service = sinon.createStubInstance UsersService


	it "should display an empty list", ->
		service.items.returns [ ]

		UsersController scope, service

		scope.users.should.have.length 0

	it "should display the current users", ->
		barry = name : "Barry"
		michael = name : "Michael"
		service.items.returns [ barry, michael ]

		UsersController scope, service

		scope.users.should.contain barry
		scope.users.should.contain michael