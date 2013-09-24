'use strict'

angular.module('TstCoreServices')
  .provider 'MqService', {
    #This can be atmosphere, socketIO, or by default a simple websocket wrapper
    mqConnector: null

    mqUrl: null
    userName: null

    #Configurable properties of the service provider
    setMqConnector: (mqConnector) -> @mqConnector = mqConnector
    setMqUrl: (mqUrl) -> @mqUrl = mqUrl
    setUserName: (userName) -> @userName = userName

    $get: (DEFAULT_MQ_WS_URL, DEFAULT_USER, WebSocketConnector) ->
      connector = @mqConnector || WebSocketConnector
      mqUrl = @mqUrl || DEFAULT_MQ_WS_URL
      userName = @userName || DEFAULT_USER
      connector.init(mqUrl)

      return {
        listenChannel: (channel, consumerName=userName, isB64=0, callback) ->
          if not channel then return
          payload = {
            consumerName: consumerName,
            action: 'listen',
            isB64: isB64,
            channel: channel
          }
          connector.sendMessage(angular.toJson(payload))
          connector.addCallback(channel, callback, 'message')

        stopListenChannel: (channel, callback) ->
          payload = {
            action: 'stop_listen',
            channel: channel
          }
          connector.sendMessage(angular.toJson(payload))
          connector.removeCallback(channel, callback, 'message')

        getChannelStatus: (channel, callback) ->
          payload = {
            action: 'channel_status',
            channel: channel
          }
          connector.sendMessage(angular.toJson(payload))
          connector.addCallback(channel, callback, 'oneTime')

        monitorChannelStatus: (channel, callback) ->
          payload = {
            action: 'monitor_channel_status',
            channel: channel
          }
          connector.sendMessage(angular.toJson(payload))
          connector.addCallback(channel, callback, 'status')

        stopMonitorChannelStatus: (channel, callback) ->
          payload = {
            action: 'stop_monitor_channel_status',
            channel: channel
          }
          connector.sendMessage(angular.toJson(payload))
          connector.removeCallback(channel, callback, 'status')

        sendMessages: (channel, messages, sourceName=userName, isB64=0) ->
          if not (channel and messages) then return
          if not angular.isArray(messages) then messages = [messages]
          payload = {
            action: 'send',
            isB64: isB64,
            messages: @buildPayloadMessages(channel, messages, sourceName)
          }
          connector.sendMessage(angular.toJson(payload))

        sendMessagesToChannels: (channelMessages, sourceName=userName, isB64=0) ->
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
          connector.sendMessages(angular.toJson(payload))

        buildPayloadMessages: (channel, messages, sourceName) ->
          payloadMessages = []
          for message in messages
            payloadMessages.push({
              channel: channel,
              source: sourceName,
              content: message
            })
          return payloadMessages
      }
  }
