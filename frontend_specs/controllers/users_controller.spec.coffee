describe "UsersController", ->

  scope = usersService = users = undefined

  beforeEach module("timeline")

  beforeEach inject (_$rootScope_) ->
    scope = _$rootScope_.$new()

  beforeEach ->
    usersService = sinon.createStubInstance UsersService
    barry = name: "Barry"
    michael = name: "Michael"
    users = [ barry, michael ]
    usersService.getUsers.yields users

  it "should display the list of users", ->
    usersController = UsersController scope, usersService

    scope.users.should.eql users

  describe 'when adding a new user', ->
    event = form_values = new_user = undefined

    beforeEach ->
      scope.userForm = $setPristine: sinon.spy()
      event = preventDefault: sinon.stub()
      form_values =
        name: "Barry",
        urNumber: "1234567890",
        age:"35",
        gender:"male"
      new_user = name: "Noob", urNumber: "12345678"
      usersService.createUser.yields new_user

    it 'creates a new user', ->
      usersController = UsersController scope, usersService
      scope.newUser = form_values

      scope.createUser(event)

      usersService.createUser.should.have.been.calledWith form_values

    it 'displays the new user', ->
      usersController = UsersController scope, usersService

      scope.createUser(event)

      scope.users.should.contain.members [new_user]

    it 'resets the new user values', ->
      usersController = UsersController scope, usersService

      scope.newUser = form_values
      scope.createUser(event)

      scope.newUser.should.be.empty

    it 'marks all fields as pristine', ->
      usersController = UsersController scope, usersService

      scope.newUser = form_values
      scope.createUser(event)

      scope.userForm.$setPristine.should.have.been.called