describe "UsersController", ->

  scope = timeout = usersService = users = messages = undefined

  beforeEach module("timeline")
  beforeEach inject (_$rootScope_, _$timeout_) ->
    scope = _$rootScope_.$new()
    timeout = _$timeout_
  beforeEach ->
    usersService = sinon.createStubInstance UsersService
    users = [ 
      { name: "Barry" },
      { name: "Michael" }
    ]
    usersService.getUsers.yields users

    messages = sinon.createStubInstance MessagesList
    sinon.stub(window, "MessagesList").returns messages
  
  afterEach -> MessagesList.restore()    

  it "should display the list of users", ->
    UsersController scope, timeout, usersService

    scope.users.should.eql users

  describe "creating a new user", ->

    createUserResult = undefined

    beforeEach ->
      newUser = name: "Barry", urNumber: "1234567890", age:"35", gender:"male"
      createdUser = _id: {$oid: "database-id"}, name: "Returned from service"
      createUserResult = user: createdUser
      usersService.createUser.withArgs(newUser).yields createUserResult

      scope.newUserForm = $setPristine: sinon.spy()
      scope.newUser = newUser

      UsersController scope, timeout, usersService

    describe "creation succeeds", ->

      beforeEach -> createUserResult.success = true

      it "displays the new user", ->
        scope.createUser()

        scope.users[2].should.eql createUserResult.user

      it "clears the form", ->
        scope.createUser()

        scope.newUser.should.be.empty
        scope.newUserForm.$setPristine.should.have.been.called

      it "displays a success message", ->
        scope.createUser()

        scope.messages.add.should.have.been.calledWith "User created successfully", "success"

    describe "creation fails", ->
      errorMessage = "Could not create user"
      beforeEach ->
        createUserResult.success = false
        createUserResult.message = errorMessage

      it "displays an the error message", ->
        scope.createUser()

        scope.messages.add.should.have.been.calledWith errorMessage, "danger"


