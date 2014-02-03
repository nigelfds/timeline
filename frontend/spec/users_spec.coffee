describe "UserController", ->

	scope = userController = userService = undefined

	beforeEach module 'timeline'

	beforeEach inject ($controller, $rootScope, _UserService_) ->
    	scope = $rootScope.$new()
    	userService = {
    		getUsers: sinon.spy()
    	}

    	userController = $controller 'UserController', {
      		$scope: scope
      		UserService: userService
    	}

	it "should display an empty list", ->
		scope.users.should.have.length 0

	it "should call the getUsers method", ->
		expect(userService.getUsers.called).to.be.true

	it "should display a user", ->
		scope.users.should.have.length 0