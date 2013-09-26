'use strict'

class @BaseWebSocketConnector
  constructor: (promiseService=Q, scopeService)->
    @ws = null
    @deferred = promiseService.defer()
    #if promiseService
    #  @deferred = promiseService.defer()
    #@deferred = $q.defer()
    @messageCallbacks = {}
    @statusCallbacks = {}
    @oneTimeCallbacks = {}

  connect: (mqUrl, callback) ->
    console.log('attempting to connect to url', callback)
    @ws = new WebSocket(mqUrl)
    @openCallback = callback

    @ws.onopen = (event) =>
      @onOpenHandler(event)

    @ws.onmessage = (event) =>
      message = JSON.parse(event.data)
      messageInfo = @getMessageInfo(message)
      messageType = messageInfo.type
      channel = messageInfo.channel
      channelCallbacks = @messageCallbacks
      runOnceOnly = false

      if messageType is 'status'
        channelCallbacks = @statusCallbacks
      else if messageType is 'oneTime'
        channelCallbacks = @oneTimeCallbacks
        runOnceOnly = true

      callbacks = channelCallbacks[channel]
      if not callbacks then return
      callbacks.runCallbacks(message, runOnceOnly)

    @ws.onclose = (event) =>
      if @closeCallback
        @closeCallback(event)
        @closeCallback = null

    @ws.onerror = (event) ->
      console.log('on error', event)

  disconnect: (callback) ->
    @closeCallback = callback
    @ws.close()
    @ws = null

  isConnected: ->
    return if @ws then @ws.readyState is WebSocket.OPEN else false

  getMessageInfo: (message) ->
    messageInfo = {
      type: 'message',
      channel: message.channel
    }

    #check and see if it's a status message based message contents
    if message.consumerNames
      messageInfo.type = 'oneTime'
    content = message.content
    try
      content = JSON.parse(message.content)
      if content.consumerNames
        messageInfo.type = 'status'
        messageInfo.channel = content.channel
    catch e
      return messageInfo
    return messageInfo

  onOpenHandler: (event) ->
    console.log('openned ws!', @openCallback)
    if @openCallback
      console.log('calling opencallback...')
      @openCallback(event)
      @openCallback = null

    @deferred.resolve(event)

    #this is pure magic...
    #$rootScope.$apply(angular.bind(@, () ->
    #  @deferred.resolve())
    #)

  sendMessage: (payload) ->
    console.log('attempting to send', payload)
    if @ws.readyState is WebSocket.OPEN
      console.log('ws OK, sending...')
      @ws.send(payload)
    else
      console.log('not ready, setting up promise')
      promise = @deferred.promise
      promise.then => @ws.send(payload)

    ###
    else
      promise = @deferred.promise
      promise.then( angular.bind(@, () ->
        @ws.send(payload)
      ))
    ###

  addCallback: (channel, callback, type) ->
    channelCallbacks = @messageCallbacks
    if type is 'status' then channelCallbacks = @statusCallbacks
    else if type is 'oneTime' then channelCallbacks = @oneTimeCallbacks
    if not channelCallbacks[channel]
      channelCallbacks[channel] = new CallbackContainer()
    channelCallbacks[channel].addCallback(callback)

  removeCallback: (channel, callbackToRemove, type) ->
    channelCallbacks = @messageCallbacks
    if type is 'status' then channelCallbacks = @statusCallbacks
    callbacks = channelCallbacks[channel]
    if not callbacks then return
    callbacks.removeCallback(callbackToRemove)
