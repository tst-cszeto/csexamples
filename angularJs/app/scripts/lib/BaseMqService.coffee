'use strict'

class @BaseMqService
  
  constructor: (url, user, connectorService) ->
    @connector = connectorService
    @mqUrl = url
    @userName = user

  connect: (mqUrl, callback) ->
    mqUrl = mqUrl || @mqUrl
    @connector.connect(mqUrl, callback)

  disconnect: (callback) -> @connector.disconnect(callback)

  isConnected: -> return @connector.isConnected()

  listenChannel: (channel, consumerName=@userName, isB64=0, callback) ->
    if not channel then return
    payload = {
      consumerName: consumerName,
      action: 'listen',
      isB64: isB64,
      channel: channel
    }
    @connector.sendMessage(JSON.stringify(payload))
    @connector.addCallback(channel, callback, 'message')

  stopListenChannel: (channel, callback) ->
    payload = {
      action: 'stop_listen',
      channel: channel
    }
    @connector.sendMessage(JSON.stringify(payload))
    @connector.removeCallback(channel, callback, 'message')

  getChannelStatus: (channel, callback) ->
    payload = {
      action: 'channel_status',
      channel: channel
    }
    @connector.sendMessage(JSON.stringify(payload))
    @connector.addCallback(channel, callback, 'oneTime')

  monitorChannelStatus: (channel, callback) ->
    payload = {
      action: 'monitor_channel_status',
      channel: channel
    }
    @connector.sendMessage(JSON.stringify(payload))
    @connector.addCallback(channel, callback, 'status')

  stopMonitorChannelStatus: (channel, callback) ->
    payload = {
      action: 'stop_monitor_channel_status',
      channel: channel
    }
    @connector.sendMessage(JSON.stringify(payload))
    @connector.removeCallback(channel, callback, 'status')

  sendMessages: (channel, messages, sourceName=@userName, isB64=0) ->
    if not (channel and messages) then return
    if messages not instanceof Array then messages = [messages]
    payload = {
      action: 'send',
      isB64: isB64,
      messages: @buildPayloadMessages(channel, messages, sourceName)
    }
    @connector.sendMessage(JSON.stringify(payload))

  sendMessagesToChannels: (channelMessages, sourceName=@userName, isB64=0) ->
    if not channelMessages then return
    payloadMessages = []
    for channel in channelMessages
      messages = channelMessages[channel]
      payloadMessages.concat(@buildPayloadMessages(channel, messages, sourceName))

    payload = {
      action: 'send',
      isB64: isB64,
      messages: payloadMessages
    }
    @connector.sendMessages(JSON.stringify(payload))

  buildPayloadMessages: (channel, messages, sourceName) ->
    payloadMessages = []
    for message in messages
      payloadMessages.push({
        channel: channel,
        source: sourceName,
        content: message
      })
    return payloadMessages
