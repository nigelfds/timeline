describe "MessagesList", ->

  messageList = timeout = undefined

  beforeEach module("timeline")
  beforeEach inject (_$timeout_) -> timeout = _$timeout_
  beforeEach ->
    messageList = new MessagesList(timeout)

  it "adds a message to the list", ->
    messageList.add "text", "type"

    messageList[0].text.should.eql "text"
    messageList[0].type.should.eql "type"

  it "removes alerts after a timeout", ->
    messageList.add "text", "type"

    timeout.flush(5000)
    messageList.length.should.be.zero