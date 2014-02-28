class MessagesList extends Array
  constructor: (@timeout) -> super()

  add: (text, type) ->
    @push(text: text, type: type)

    @timeout ( => @shift() ), 3000

window.MessagesList = MessagesList